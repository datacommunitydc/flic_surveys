library(shiny)
library(shinydashboard)
library(httr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(magrittr)
library(dplyr)

all_answers <- 

shinyServer(function(input, output, session) {

  all_questions <- eventReactive(input$reload_questions, {
    ret <- GET(config_questions_url) %>% content() %>%
      mutate(from_timestamp = mdy_hms(from_timestamp),
             to_timestamp = mdy_hms(to_timestamp))
    choices <- ret$question_id; names(choices) <- ret$question
    updateSelectInput(session, "question_id",  choices=choices)
    ret
  }, ignoreNULL=FALSE)
  
  all_answers <- eventReactive(input$reload_questions, {
    GET(config_answers_url) %>% content()
  }, ignoreNULL=FALSE)
  
  questions <- reactive({
    message("questions")
    filter(all_questions(), question_id == input$question_id)
  })
  answers <- reactive({
    message("answers")
    filter(all_answers(), question_id == input$question_id)
  })
  
  responses <- reactivePoll(15000, session, function(x) rnorm(1), function(y) {
    message("responses")
    GET(responses_url) %>% content() %>%
      mutate(datetime = mdy_hm(datetime)) %>%
      filter(datetime >= questions()$from_timestamp) %>%
      filter(datetime <= questions()$to_timestamp) %>% 
      left_join(answers(), by="button")
  })
  
  output$responses <- renderPlot({
    message("plot responses")
    ggplot(responses(), aes(answer)) + 
      geom_bar() + 
      xlab("") +
      coord_flip() + 
      ggtitle(questions()$question) + 
      theme_bw(base_size=18)
  })
  
})
