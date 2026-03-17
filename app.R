#
# Cardiovascular Clinical Explorer
# Shiny App
# Exploring Shiny Capabilities
#

options(stringsAsFactors = FALSE)

# Libraries ----

library(shiny)
library(dplyr)
library(ggplot2)
library(shinythemes)
library(psych)
library(haven)
library(DT)

# Load dataset 

heart <- read_sas("heart.sas7bdat")

# Risk score 

heart <- heart %>%
  
  mutate(
    
    risk_score =
      
      ifelse(BP_Status=="High",1,0) +
      ifelse(Chol_Status=="High",1,0) +
      ifelse(Smoking_Status!="Non-smoker",1,0) +
      ifelse(Weight_Status %in%
               c("Overweight","Obese"),1,0)
    
  )

# Risk category 

heart <- heart %>%
  
  mutate(
    
    risk_category = case_when(
      
      risk_score==0 ~ "Low",
      
      risk_score %in% c(1,2) ~ "Moderate",
      
      risk_score %in% c(3,4) ~ "High",
      
      TRUE ~ NA_character_
      
    )
    
  )

# Age limits 

age_min <- min(heart$AgeAtStart,na.rm=TRUE)

age_max <- max(heart$AgeAtStart,na.rm=TRUE)



# UI ---- User interface

ui <- fluidPage(
  
  theme = shinytheme("slate"),
  
  # Fix DT dark theme issue
  
  tags$style(HTML("

table.dataTable {
color: white;
}

.dataTables_wrapper {
color: white;
}

.dataTables_filter label {
color:white;
}

")),
  
  titlePanel("Cardiovascular Clinical Explorer"),
  
  p("Interactive exploration of cardiovascular risk factors",
    style="color:lightgray"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      h4("Population Filters",
         style="color:#4FC3F7"),
      
      selectInput(
        "sex",
        "Gender",
        choices=c("All",
                  na.omit(unique(heart$Sex)))
      ),
      
      selectInput(
        "smoke",
        "Smoking Status",
        choices=c("All",
                  na.omit(unique(heart$Smoking_Status)))
      ),
      
      selectInput(
        "bp",
        "Blood Pressure",
        choices=c("All",
                  na.omit(unique(heart$BP_Status)))
      ),
      
      selectInput(
        "weight",
        "Weight Category",
        choices=c("All",
                  na.omit(unique(heart$Weight_Status)))
      ),
      
      sliderInput(
        
        "age",
        
        "Age Range",
        
        min=age_min,
        
        max=age_max,
        
        value=c(age_min,age_max)
        
      ),
      
      hr(),
      
      h4("Clinical Relationship Explorer",
         style="color:#4FC3F7"),
      
      selectInput(
        
        "xvar",
        
        "X variable",
        
        choices=c(
          "AgeAtStart",
          "Cholesterol",
          "Systolic",
          "Diastolic",
          "risk_score"
        ),
        
        selected="AgeAtStart"
        
      ),
      
      selectInput(
        
        "yvar",
        
        "Y variable",
        
        choices=c(
          "Cholesterol",
          "Systolic",
          "Diastolic",
          "risk_score"
        ),
        
        selected="Cholesterol"
        
      ),
      
      selectInput(
        
        "color",
        
        "Color by",
        
        choices=c(
          "risk_category",
          "Sex",
          "Smoking_Status",
          "BP_Status",
          "Weight_Status"
        ),
        
        selected="risk_category"
        
      ),
      
      selectInput(
        
        "size",
        
        "Bubble size",
        
        choices=c(
          "risk_score",
          "Cholesterol",
          "Systolic"
        ),
        
        selected="risk_score"
        
      )
      
    ),
    
    mainPanel(
      
      tabsetPanel(
        
        tabPanel(
          
          "Study Population",
          
          h3("Summary Statistics"),
          
          tableOutput("stats"),
          
          br(),
          
          plotOutput("agedist")
          
        ),
        
        tabPanel(
          
          "Risk Factors",
          
          plotOutput("riskdist"),
          
          br(),
          
          plotOutput("risksmoke"),
          
          br(),
          
          plotOutput("riskbp")
          
        ),
        
        tabPanel(
          
          "Clinical Explorer",
          
          h3("Variable Relationship Explorer"),
          
          plotOutput(
            "scatter",
            height="550px"
          )
          
        ),
        
        tabPanel(
          
          "Dataset",
          
          h3("Clinical Dataset"),
          
          p("Filtered dataset based on selected filters",
            style="color:lightgray"),
          
          DTOutput("datatable")
          
        )
        
      )
      
    )
    
  )
  
)



# Server 

server <- function(input,output){
  
  filtered <- reactive({
    
    data <- heart
    
    if(input$sex!="All"){
      
      data <- data %>%
        filter(Sex==input$sex)
      
    }
    
    if(input$smoke!="All"){
      
      data <- data %>%
        filter(Smoking_Status==input$smoke)
      
    }
    
    if(input$bp!="All"){
      
      data <- data %>%
        filter(BP_Status==input$bp)
      
    }
    
    if(input$weight!="All"){
      
      data <- data %>%
        filter(Weight_Status==input$weight)
      
    }
    
    data <- data %>%
      
      filter(
        
        !is.na(AgeAtStart),
        
        AgeAtStart>=input$age[1],
        
        AgeAtStart<=input$age[2]
        
      )
    
    data
    
  })
  
  
  
  # Summary statistics 
  
  output$stats <- renderTable({
    
    data <- filtered()
    
    if(nrow(data)==0){
      return(NULL)
    }
    
    describe(
      
      na.omit(
        
        data[,c(
          
          "AgeAtStart",
          "Cholesterol",
          "Systolic",
          "Diastolic",
          "risk_score"
          
        )]
        
      )
      
    )
    
  },rownames=TRUE)
  
  
  
  # Age distribution 
  
  output$agedist <- renderPlot({
    
    ggplot(
      filtered(),
      aes(AgeAtStart)
    )+
      
      geom_histogram(
        
        fill="#4FC3F7",
        
        bins=25
        
      )+
      
      theme_minimal()+
      
      labs(
        
        title="Age Distribution",
        
        x="Age",
        
        y="Patients"
        
      )
    
  })
  
  
  
  # Risk distribution 
  
  output$riskdist <- renderPlot({
    
    ggplot(
      filtered(),
      aes(risk_category,
          fill=risk_category)
    )+
      
      geom_bar()+
      
      scale_fill_manual(values=c(
        
        "Low"="#2ECC71",
        
        "Moderate"="#F1C40F",
        
        "High"="#E74C3C"
        
      ))+
      
      theme_minimal()+
      
      labs(
        
        title="Overall Risk Distribution",
        
        x="Risk Category",
        
        y="Patients"
        
      )
    
  })
  
  
  
  # Risk vs smoking 
  
  output$risksmoke <- renderPlot({
    
    ggplot(
      filtered(),
      aes(
        Smoking_Status,
        fill=risk_category
      )
    )+
      
      geom_bar(position="fill")+
      
      scale_fill_manual(values=c(
        
        "Low"="#2ECC71",
        
        "Moderate"="#F1C40F",
        
        "High"="#E74C3C"
        
      ))+
      
      theme_minimal()+
      
      theme(
        
        axis.text.x=
          element_text(
            angle=45,
            hjust=1
          )
        
      )+
      
      labs(
        
        title="Risk Distribution by Smoking",
        
        x="Smoking",
        
        y="Proportion"
        
      )
    
  })
  
  
  
  # Risk vs BP 
  
  output$riskbp <- renderPlot({
    
    ggplot(
      filtered(),
      aes(
        BP_Status,
        fill=risk_category
      )
    )+
      
      geom_bar(position="fill")+
      
      scale_fill_manual(values=c(
        
        "Low"="#2ECC71",
        
        "Moderate"="#F1C40F",
        
        "High"="#E74C3C"
        
      ))+
      
      theme_minimal()+
      
      labs(
        
        title="Risk Distribution by Blood Pressure",
        
        x="BP Status",
        
        y="Proportion"
        
      )
    
  })
  
  
  
  # Clinical explorer
  
  output$scatter <- renderPlot({
    
    ggplot(
      filtered(),
      aes(
        x=.data[[input$xvar]],
        y=.data[[input$yvar]],
        color=.data[[input$color]],
        size=.data[[input$size]]
      )
    )+
      
      geom_point(alpha=.7)+
      
      theme_minimal()+
      
      labs(
        
        title=paste(
          input$yvar,
          "vs",
          input$xvar
        ),
        
        x=input$xvar,
        
        y=input$yvar
        
      )
    
  })
  
  
  
  # Dataset table 
  
  output$datatable <- renderDT({
    
    datatable(
      
      filtered(),
      
      filter="top",
      
      extensions='Buttons',
      
      options=list(
        
        pageLength=10,
        
        scrollX=TRUE,
        
        dom='Bfrtip',
        
        buttons=c('copy','csv','excel')
        
      ),
      
      class='display',
      
      rownames=FALSE
      
    )
    
  })
  
}



# Run Shiny app 

shinyApp(ui = ui, server = server)
