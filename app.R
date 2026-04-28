library(shiny)
library(shinythemes)
library(DT)
library(dplyr)
library(lubridate)
library(ggplot2)
library(shinyWidgets)
library(shinydashboard)
library(plotly)
library(viridis)
library(scales)
library(fs)
library(shinyjs)

# UI of the application
ui <- fluidPage(
  useShinyjs(),
  theme = shinytheme("flatly"),
  tags$head(
    tags$style(HTML("
      :root {
        --primary: #2c3e50;
        --secondary: #18bc9c;
        --accent: #3498db;
        --light: #ecf0f1;
        --dark: #2c3e50;
      }
      
      body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f8f9fa;
      }
      
      .main-header {
        background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
        color: white;
        padding: 2rem 0;
        margin-bottom: 2rem;
        border-radius: 0 0 10px 10px;
      }
      
      .card {
        border: none;
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;
        margin-bottom: 20px;
      }
      
      .card:hover {
        transform: translateY(-5px);
      }
      
      .card-header {
        background-color: white;
        border-bottom: 2px solid var(--light);
        font-weight: 600;
        color: var(--primary);
      }
      
      .btn-primary {
        background-color: var(--secondary);
        border: none;
        padding: 10px 20px;
        font-weight: 600;
      }
      
      .btn-primary:hover {
        background-color: #139a7d;
      }
      
      .btn-warning {
        background-color: #f39c12;
        border: none;
        padding: 10px 20px;
        font-weight: 600;
        color: white;
      }
      
      .btn-warning:hover {
        background-color: #e67e22;
      }
      
      .btn-danger {
        background-color: #e74c3c;
        border: none;
        padding: 10px 20px;
        font-weight: 600;
        color: white;
      }
      
      .btn-danger:hover {
        background-color: #c0392b;
      }
      
      .btn-success {
        background-color: #27ae60;
        border: none;
        padding: 10px 20px;
        font-weight: 600;
        color: white;
      }
      
      .btn-success:hover {
        background-color: #219a52;
      }
      
      .btn-info {
        background-color: var(--accent);
        border: none;
        padding: 5px 10px;
        font-weight: 600;
        color: white;
      }
      
      .btn-info:hover {
        background-color: #2980b9;
      }
      
      .well-panel-custom {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin-bottom: 20px;
      }
      
      .project-highlight {
        background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 15px;
      }
      
      .feature-list {
        list-style-type: none;
        padding-left: 0;
      }
      
      .feature-list li {
        padding: 8px 0;
        border-bottom: 1px solid #eee;
      }
      
      .feature-list li:before {
        content: '✓';
        margin-right: 10px;
        color: var(--secondary);
        font-weight: bold;
      }
      
      .stats-card {
        text-align: center;
        padding: 1.5rem;
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        margin-bottom: 20px;
      }
      
      .stats-number {
        font-size: 2.5rem;
        font-weight: 700;
        color: var(--primary);
      }
      
      .stats-label {
        font-size: 1rem;
        color: #6B7280;
      }
      
      .selection-info {
        background-color: #e8f5e8;
        border-left: 4px solid var(--secondary);
        padding: 10px;
        margin: 10px 0;
        border-radius: 4px;
      }
      
      .filter-panel {
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-radius: 10px;
        padding: 15px;
        margin-bottom: 20px;
        border-left: 4px solid var(--secondary);
      }
      
      .btn-icon {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 5px;
      }
      
      .btn-filter {
        background-color: var(--secondary);
        color: white;
        border: none;
      }
      
      .btn-filter:hover {
        background-color: #139a7d;
        transform: scale(1.1);
      }
      
      .btn-reset {
        background-color: #f39c12;
        color: white;
        border: none;
      }
      
      .btn-reset:hover {
        background-color: #e67e22;
        transform: scale(1.1);
      }
      
      .file-upload-area {
        border: 2px dashed var(--secondary);
        border-radius: 10px;
        padding: 20px;
        text-align: center;
        background-color: #f8f9fa;
        margin-bottom: 15px;
      }
      
      .file-upload-area:hover {
        background-color: #e8f5e8;
      }
      
      .image-gallery {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 15px;
        margin-top: 15px;
      }
      
      .image-item {
        position: relative;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        transition: transform 0.3s ease;
      }
      
      .image-item:hover {
        transform: scale(1.05);
        z-index: 10;
      }
      
      .image-item img {
        width: 100%;
        height: 150px;
        object-fit: cover;
        cursor: pointer;
      }
      
      .image-caption {
        padding: 10px;
        background-color: white;
        font-size: 0.9rem;
      }
      
      .delete-image {
        position: absolute;
        top: 5px;
        right: 5px;
        background-color: rgba(231, 76, 60, 0.8);
        color: white;
        border: none;
        border-radius: 50%;
        width: 30px;
        height: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        z-index: 20;
      }
      
      .delete-image:hover {
        background-color: #c0392b;
      }
      
      .pdf-viewer {
        width: 100%;
        height: 80vh;
        border: none;
      }
      
      .modal-xl {
        width: 95%;
        max-width: 1200px;
      }
      
      .rapport-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 12px;
        background-color: #f8f9fa;
        border-radius: 8px;
        margin-bottom: 8px;
        border-left: 4px solid var(--accent);
      }
      
      .rapport-item:hover {
        background-color: #e9ecef;
      }
      
      .progress-indicator {
        width: 100%;
        height: 12px;
        background-color: #f0f0f0;
        border-radius: 6px;
        overflow: hidden;
        margin-top: 10px;
      }
      
      .progress-bar-activity {
        height: 100%;
        background: linear-gradient(90deg, var(--secondary) 0%, var(--accent) 100%);
        transition: width 0.3s ease;
        border-radius: 6px;
      }
      
      .activity-detail-progress {
        padding: 20px;
        background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        border-radius: 10px;
        margin-bottom: 20px;
        border: 1px solid #dee2e6;
      }
      
      .text-preview {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        max-height: 70vh;
        overflow-y: auto;
        font-family: monospace;
        white-space: pre-wrap;
        border: 1px solid #dee2e6;
      }
      
      .document-link {
        color: var(--accent);
        text-decoration: none;
        font-weight: 500;
      }
      
      .document-link:hover {
        text-decoration: underline;
      }
      
      /* Styles pour le scroll des graphiques */
      .scrollable-plot-container {
        width: 100%;
        max-height: 500px;
        overflow-y: auto;
        overflow-x: hidden;
        border-radius: 6px;
        position: relative;
      }
      
      /* Personnalisation de la barre de défilement */
      .scrollable-plot-container::-webkit-scrollbar {
        width: 6px;
      }
      
      .scrollable-plot-container::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 10px;
      }
      
      .scrollable-plot-container::-webkit-scrollbar-thumb {
        background: var(--secondary);
        border-radius: 10px;
      }
      
      .scrollable-plot-container::-webkit-scrollbar-thumb:hover {
        background: #139a7d;
      }
      
      .gauge-container {
        width: 100%;
        max-height: 500px;
        overflow-y: auto;
        margin-top: 20px;
      }
      
      .progress-bar-container {
        margin-bottom: 15px;
        padding: 10px;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
      }
      
      .progress-bar-label {
        display: flex;
        justify-content: space-between;
        margin-bottom: 5px;
        font-size: 0.9rem;
      }
      
      .progress-bar-label .activity-name {
        font-weight: 600;
        color: var(--primary);
      }
      
      .progress-bar-label .progress-value {
        font-weight: 600;
        color: var(--secondary);
      }
      
      .custom-progress {
        width: 100%;
        height: 20px;
        background-color: #f0f0f0;
        border-radius: 10px;
        overflow: hidden;
        position: relative;
      }
      
      .custom-progress-bar {
        height: 100%;
        transition: width 0.3s ease;
        border-radius: 10px;
        position: relative;
        display: flex;
        align-items: center;
        justify-content: flex-end;
        padding-right: 5px;
        color: white;
        font-size: 0.8rem;
        font-weight: bold;
        text-shadow: 0 1px 2px rgba(0,0,0,0.2);
      }
      
      .progress-0 { background: linear-gradient(90deg, #EF4444, #F87171); }
      .progress-25 { background: linear-gradient(90deg, #F59E0B, #FBBF24); }
      .progress-50 { background: linear-gradient(90deg, #3B82F6, #60A5FA); }
      .progress-75 { background: linear-gradient(90deg, #10B981, #34D399); }
      .progress-100 { background: linear-gradient(90deg, #059669, #10B981); }
      
      .gauge-title {
        font-size: 1.2rem;
        font-weight: 600;
        color: var(--primary);
        margin-bottom: 20px;
        text-align: center;
      }
      
      /* Nouveaux styles pour les onglets internes */
      .inner-tab {
        margin-bottom: 20px;
      }
      
      .inner-tab .nav-tabs {
        border-bottom: 2px solid var(--light);
      }
      
      .inner-tab .nav-tabs .nav-link {
        border: none;
        color: var(--primary);
        font-weight: 600;
        padding: 10px 20px;
        transition: all 0.3s ease;
      }
      
      .inner-tab .nav-tabs .nav-link:hover {
        border-bottom: 2px solid var(--secondary);
        color: var(--secondary);
      }
      
      .inner-tab .nav-tabs .nav-link.active {
        border-bottom: 2px solid var(--secondary);
        color: var(--secondary);
        background-color: transparent;
      }
      
      .doc-stats-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 10px;
        padding: 15px;
        margin-bottom: 15px;
        text-align: center;
      }
      
      .doc-stats-number {
        font-size: 2rem;
        font-weight: bold;
      }
      
      .quick-upload-area {
        border: 2px dashed var(--secondary);
        border-radius: 10px;
        padding: 15px;
        text-align: center;
        background-color: #f8f9fa;
        margin-bottom: 15px;
        transition: all 0.3s ease;
      }
      
      .quick-upload-area:hover {
        background-color: #e8f5e8;
        transform: scale(1.02);
      }
    "))
  ),
  
  navbarPage(
    title = div(
      img(src = "https://cdn-icons-png.flaticon.com/512/3713/3713763.png", height = "30px"),
      "Planification ONG"
    ),
    windowTitle = "Application de Planification pour ONG",
    inverse = TRUE,
    collapsible = TRUE,
    id = "nav",
    
    tabPanel(
      "Accueil",
      icon = icon("home"),
      div(class = "main-header",
          div(class = "container-fluid",
              h1("Plateforme de Gestion de Projets pour ONG", class = "text-center"),
              p("Optimisez la planification, le suivi et l'évaluation de vos activités humanitaires", 
                class = "text-center lead")
          )
      ),
      div(class = "container-fluid full-width-content",
          fluidRow(
            column(12,
                   div(class = "card",
                       div(class = "card-body",
                           h3("À propos du projet", class = "text-center", style = "color: var(--primary);"),
                           p("Cette application a été développée pour faciliter la gestion des activités des organisations non gouvernementales."),
                           div(class = "project-highlight",
                               h4("Fonctionnalités principales"),
                               tags$ul(class = "feature-list",
                                       tags$li("Saisie et gestion des activités projet"),
                                       tags$li("Upload et visualisation des rapports (PDF, TXT)"),
                                       tags$li("Upload et visualisation des images"),
                                       tags$li("Tableaux de bord analytiques"),
                                       tags$li("Gestion documentaire par activité"),
                                       tags$li("Graphique de progression des activités")
                               )
                           )
                       )
                   )
            )
          )
      )
    ),
    
    tabPanel(
      "Saisie des Activités",
      icon = icon("pen-to-square"),
      div(class = "container-fluid",
          fluidRow(
            column(12,
                   div(class = "well-panel-custom",
                       h4("Nouvelle Activité", style = "color: var(--primary);"),
                       fluidRow(
                         column(6, numericInput("num_activite", "N° de l'Activité:", value = 1, min = 1, width = "100%")),
                         column(6, textInput("nom_activite", "Nom de l'Activité:", placeholder = "Saisir le nom de l'activité", width = "100%"))
                       ),
                       fluidRow(
                         column(6, textInput("responsable", "Responsable:", placeholder = "Saisir le nom du responsable", width = "100%")),
                         column(6, selectInput("priorite", "Priorité:", choices = c("Faible", "Moyenne", "Élevée", "Critique"), selected = "Moyenne", width = "100%"))
                       ),
                       fluidRow(
                         column(6, dateRangeInput("periode_prevue", "Période prévue:", start = Sys.Date(), end = Sys.Date() + 7, width = "100%")),
                         column(6, dateRangeInput("periode_reelle", "Période réelle:", start = NULL, end = NULL, width = "100%"))
                       ),
                       fluidRow(
                         column(6, numericInput("nb_taches", "Nombre de tâches:", value = 1, min = 1, width = "100%")),
                         column(6, numericInput("taches_completees", "Tâches complétées:", value = 0, min = 0, width = "100%"))
                       ),
                       fluidRow(
                         column(6, numericInput("budget_alloue_prevu", "Budget prévu (€):", value = 0, min = 0, width = "100%")),
                         column(6, numericInput("budget_alloue_reel", "Budget réel (€):", value = 0, min = 0, width = "100%"))
                       ),
                       fluidRow(
                         column(12, textAreaInput("description", "Description:", placeholder = "Description détaillée de l'activité...", rows = 3, width = "100%"))
                       ),
                       fluidRow(
                         column(12, style = "text-align: center; margin-top: 20px;",
                                actionButton("ajouter_activite", "Ajouter l'Activité", class = "btn-primary", icon = icon("plus")),
                                actionButton("modifier_activite", "Modifier l'activité sélectionnée", class = "btn-warning", icon = icon("edit")),
                                actionButton("supprimer_activite", "Supprimer l'activité sélectionnée", class = "btn-danger", icon = icon("trash")),
                                actionButton("vider_formulaire", "Vider le formulaire", class = "btn-success", icon = icon("broom"))
                         )
                       )
                   )
            )
          )
      )
    ),
    
    tabPanel(
      "Base de Données",
      icon = icon("database"),
      div(class = "container-fluid",
          fluidRow(
            column(12,
                   div(class = "well-panel-custom",
                       DTOutput("tableau_base_donnees"),
                       br(),
                       downloadButton("export_data", "Exporter les données", class = "btn-success")
                   )
            )
          )
      )
    ),
    
    tabPanel(
      "Documents & Rapports",
      icon = icon("file-alt"),
      div(class = "container-fluid",
          div(class = "row",
              div(class = "col-md-3",
                  div(class = "well-panel-custom",
                      h4(icon("folder-open"), " Sélection", style = "color: var(--primary); margin-bottom: 20px;"),
                      uiOutput("select_activite_documents"),
                      br(),
                      div(class = "selection-info",
                          h5(icon("info-circle"), " Activité sélectionnée:"),
                          textOutput("selected_activity_name"),
                          textOutput("selected_activity_status"),
                          uiOutput("selected_activity_progress_bar")
                      ),
                      br(),
                      div(class = "doc-stats-card",
                          h5(icon("chart-line"), " Statistiques"),
                          uiOutput("doc_stats")
                      )
                  )
              ),
              div(class = "col-md-9",
                  div(class = "card",
                      div(class = "card-header", 
                          icon("file-alt"), " Gestion Documentaire",
                          div(class = "pull-right", style = "float: right;",
                              actionButton("refresh_docs", icon("sync"), class = "btn-info btn-sm", style = "padding: 2px 8px;")
                          )
                      ),
                      div(class = "card-body",
                          div(class = "inner-tab",
                              tabsetPanel(
                                tabPanel(
                                  icon = icon("upload"), " Upload Rapide",
                                  br(),
                                  div(class = "quick-upload-area",
                                      h5(icon("cloud-upload-alt"), " Glissez-déposez vos fichiers ici"),
                                      p("Support: PDF, TXT, JPG, PNG, GIF"),
                                      fileInput("upload_rapport", "Rapports (PDF, TXT)", 
                                                accept = c(".pdf", ".txt"), width = "100%"),
                                      fileInput("upload_images", "Images (JPG, PNG, GIF)", 
                                                accept = c(".jpg", ".jpeg", ".png", ".gif"),
                                                multiple = TRUE, width = "100%"),
                                      actionButton("upload_files", "Uploader les fichiers", 
                                                   class = "btn-primary", icon = icon("cloud-upload-alt"),
                                                   width = "100%")
                                  )
                                ),
                                tabPanel(
                                  icon = icon("file-pdf"), " Rapports",
                                  br(),
                                  conditionalPanel(
                                    condition = "input.activite_documents != '' && input.activite_documents != null",
                                    uiOutput("rapports_list")
                                  ),
                                  conditionalPanel(
                                    condition = "input.activite_documents == '' || input.activite_documents == null",
                                    div(class = "alert alert-info", icon("info-circle"),
                                        "Veuillez sélectionner une activité pour voir ses rapports.")
                                  )
                                ),
                                tabPanel(
                                  icon = icon("images"), " Galerie d'images",
                                  br(),
                                  conditionalPanel(
                                    condition = "input.activite_documents != '' && input.activite_documents != null",
                                    uiOutput("image_gallery")
                                  ),
                                  conditionalPanel(
                                    condition = "input.activite_documents == '' || input.activite_documents == null",
                                    div(class = "alert alert-info", icon("info-circle"),
                                        "Veuillez sélectionner une activité pour voir ses images.")
                                  )
                                ),
                                tabPanel(
                                  icon = icon("search"), " Recherche documents",
                                  br(),
                                  div(class = "well",
                                      textInput("search_docs", "Rechercher un document:", 
                                                placeholder = "Nom du fichier...", width = "100%"),
                                      br(),
                                      uiOutput("search_results")
                                  )
                                )
                              )
                          )
                      )
                  )
              )
          )
      )
    ),
    
    tabPanel(
      "Tableau de Bord",
      icon = icon("chart-column"),
      div(class = "container-fluid",
          div(class = "filter-panel",
              fluidRow(
                column(3, selectInput("periode_type", "Type de période:",
                                      choices = c("Global" = "global", "Annuel" = "annuel", 
                                                  "Semestriel" = "semestriel", "Trimestriel" = "trimestriel", 
                                                  "Mensuel" = "mensuel"),
                                      selected = "global", width = "100%")),
                column(3, conditionalPanel(condition = "input.periode_type != 'global'", uiOutput("periode_annee_ui"))),
                column(3, conditionalPanel(condition = "input.periode_type == 'mensuel' || input.periode_type == 'trimestriel' || input.periode_type == 'semestriel'", 
                                           uiOutput("periode_specifique_ui"))),
                column(3, conditionalPanel(condition = "input.periode_type != 'global'",
                                           div(style = "display: flex; justify-content: center; align-items: center; height: 100%;",
                                               actionButton("appliquer_filtres", NULL, class = "btn-icon btn-filter", icon = icon("filter")),
                                               actionButton("reset_filtres", NULL, class = "btn-icon btn-reset", icon = icon("refresh")))))
              )
          ),
          
          fluidRow(
            column(3, div(class = "stats-card", div(class = "stats-number", textOutput("total_activites_value")), div(class = "stats-label", "Activités Totales"))),
            column(3, div(class = "stats-card", div(class = "stats-number", textOutput("activites_terminees_value")), div(class = "stats-label", "Activités Terminées"))),
            column(3, div(class = "stats-card", div(class = "stats-number", textOutput("taux_realisation_budget_value")), div(class = "stats-label", "Taux Réalisation Budget"))),
            column(3, div(class = "stats-card", div(class = "stats-number", textOutput("taux_avancement_value")), div(class = "stats-label", "Taux d'Avancement")))
          ),
          
          fluidRow(
            column(6, div(class = "card", div(class = "card-header", "Distribution des Activités par Statut"),
                          div(class = "card-body", plotOutput("status_plot", height = "300px")))),
            column(6, div(class = "card", div(class = "card-header", "Nombre d'Activités par Priorité"),
                          div(class = "card-body", plotOutput("priority_plot", height = "300px"))))
          ),
          
          fluidRow(
            column(6, 
                   div(class = "card", 
                       div(class = "card-header", "Activités par Responsable"),
                       div(class = "card-body",
                           div(class = "scrollable-plot-container",
                               plotOutput("responsable_plot")
                           )
                       )
                   )
            ),
            column(6, 
                   div(class = "card", 
                       div(class = "card-header", "Progression des Activités"),
                       div(class = "card-body", 
                           div(class = "gauge-container",
                               uiOutput("progress_gauge")
                           )
                       )
                   )
            )
          )
      )
    )
  )
)

# Server logic
server <- function(input, output, session) {
  
  # --- Gestion des Activités ---
  activites <- reactiveVal(data.frame(
    Num_Activite = integer(),
    Nom_Activite = character(),
    Responsable = character(),
    Priorite = character(),
    Nb_Taches = integer(),
    Taches_Completees = integer(),
    Budget_Prevue = numeric(),
    Budget_Reel = numeric(),
    Description = character(),
    Statut = character(),
    Date_Debut_Prevue = as.Date(character()),
    Date_Fin_Prevue = as.Date(character()),
    Date_Debut_Reelle = as.Date(character()),
    Date_Fin_Reelle = as.Date(character()),
    stringsAsFactors = FALSE
  ))
  
  # --- Gestion des Documents ---
  upload_dir <- file.path(getwd(), "www", "ong_documents")
  if (!dir.exists(upload_dir)) {
    dir.create(upload_dir, recursive = TRUE)
    Sys.chmod(upload_dir, "0755")
  }
  
  addResourcePath("documents", upload_dir)
  
  documents_activites <- reactiveVal(list())
  
  selected_activity <- reactiveVal(NULL)
  clicked_activity <- reactiveVal(NULL)
  filters_applied <- reactiveVal(FALSE)
  filtered_data <- reactiveVal(NULL)
  
  # Hauteur dynamique pour le graphique des responsables (même hauteur que progression)
  responsable_plot_height <- reactive({
    data <- dashboard_data()
    if (nrow(data) == 0) return(500)
    
    n_responsables <- length(unique(data$Responsable[!is.na(data$Responsable)]))
    
    # Hauteur de base + espace pour les barres
    base_height <- 80
    bar_height <- 50
    
    if (n_responsables <= 8) {
      500  # Hauteur fixe identique à la progression
    } else {
      min(base_height + (bar_height * n_responsables), 800)
    }
  })
  
  # Refresh documents
  observeEvent(input$refresh_docs, {
    documents_activites(documents_activites())
    showNotification("Documents rafraîchis!", type = "message")
  })
  
  get_available_years <- function(data) {
    if (nrow(data) == 0) return(year(Sys.Date()))
    years <- unique(c(
      data %>% filter(!is.na(Date_Debut_Reelle)) %>% pull(Date_Debut_Reelle) %>% year(),
      data %>% filter(is.na(Date_Debut_Reelle)) %>% pull(Date_Debut_Prevue) %>% year()
    ))
    if (length(years) == 0) return(year(Sys.Date()))
    sort(years, decreasing = TRUE)
  }
  
  output$periode_annee_ui <- renderUI({
    selectInput("periode_annee", "Année:",
                choices = get_available_years(activites()),
                selected = get_available_years(activites())[1],
                width = "100%")
  })
  
  output$periode_specifique_ui <- renderUI({
    req(input$periode_type)
    if (input$periode_type == "mensuel") {
      selectInput("periode_specifique", "Mois:", choices = setNames(1:12, month.name),
                  selected = month(Sys.Date()), width = "100%")
    } else if (input$periode_type == "trimestriel") {
      selectInput("periode_specifique", "Trimestre:", choices = c("1" = 1, "2" = 2, "3" = 3, "4" = 4),
                  selected = quarter(Sys.Date()), width = "100%")
    } else if (input$periode_type == "semestriel") {
      selectInput("periode_specifique", "Semestre:", choices = c("1" = 1, "2" = 2),
                  selected = ifelse(month(Sys.Date()) <= 6, 1, 2), width = "100%")
    }
  })
  
  output$select_activite_documents <- renderUI({
    data <- activites()
    if (nrow(data) == 0) return(p("Aucune activité disponible"))
    selectInput("activite_documents", "Choisir une activité:",
                choices = setNames(data$Num_Activite, paste0(data$Num_Activite, " - ", data$Nom_Activite)),
                selected = NULL, width = "100%")
  })
  
  output$doc_stats <- renderUI({
    req(input$activite_documents)
    activity_num <- as.character(as.numeric(input$activite_documents))
    docs <- documents_activites()
    
    nb_rapports <- ifelse(!is.null(docs[[activity_num]]$rapports), length(docs[[activity_num]]$rapports), 0)
    nb_images <- ifelse(!is.null(docs[[activity_num]]$images), length(docs[[activity_num]]$images), 0)
    
    div(
      div(class = "doc-stats-number", nb_rapports + nb_images),
      div("Documents totaux"),
      hr(),
      div(icon("file-pdf"), " Rapports: ", strong(nb_rapports)),
      div(icon("images"), " Images: ", strong(nb_images))
    )
  })
  
  output$selected_activity_name <- renderText({
    req(input$activite_documents)
    data <- activites()
    activity <- data[data$Num_Activite == as.numeric(input$activite_documents), ]
    if (nrow(activity) > 0) paste("Nom:", activity$Nom_Activite[1])
    else ""
  })
  
  output$selected_activity_status <- renderText({
    req(input$activite_documents)
    data <- activites()
    activity <- data[data$Num_Activite == as.numeric(input$activite_documents), ]
    if (nrow(activity) > 0) paste("Statut:", activity$Statut[1])
    else ""
  })
  
  output$selected_activity_progress_bar <- renderUI({
    req(input$activite_documents)
    data <- activites()
    activity <- data[data$Num_Activite == as.numeric(input$activite_documents), ]
    if (nrow(activity) > 0 && activity$Nb_Taches[1] > 0) {
      progress <- round((activity$Taches_Completees[1] / activity$Nb_Taches[1]) * 100, 1)
      
      progress_class <- if(progress == 0) "progress-0" else if(progress < 25) "progress-25" else if(progress < 50) "progress-50" else if(progress < 75) "progress-75" else "progress-100"
      
      div(
        p(paste("Progression:", progress, "%")),
        div(class = "progress-indicator",
            div(class = paste("custom-progress-bar", progress_class), 
                style = paste0("width: ", progress, "%"),
                if(progress > 10) paste0(progress, "%") else "")
        )
      )
    }
  })
  
  # Upload des fichiers
  observeEvent(input$upload_files, {
    req(input$activite_documents)
    
    activity_num <- as.character(as.numeric(input$activite_documents))
    
    if (is.null(input$upload_rapport) && is.null(input$upload_images)) {
      showNotification("Veuillez sélectionner des fichiers à uploader!", type = "warning")
      return()
    }
    
    docs <- documents_activites()
    
    if (is.null(docs[[activity_num]])) {
      docs[[activity_num]] <- list(rapports = list(), images = list())
    }
    
    activity_dir <- file.path(upload_dir, activity_num)
    if (!dir.exists(activity_dir)) {
      dir.create(activity_dir, recursive = TRUE)
      Sys.chmod(activity_dir, "0755")
    }
    
    upload_success <- TRUE
    rapport_count <- 0
    image_count <- 0
    
    # Upload des rapports
    if (!is.null(input$upload_rapport)) {
      for (i in 1:nrow(input$upload_rapport)) {
        file_ext <- tools::file_ext(input$upload_rapport$name[i])
        timestamp <- format(Sys.time(), "%Y%m%d%H%M%S")
        new_filename <- paste0("rapport_", timestamp, "_", i, ".", file_ext)
        new_filepath <- file.path(activity_dir, new_filename)
        
        ok <- file.copy(input$upload_rapport$datapath[i], new_filepath, overwrite = TRUE)
        
        if (!ok) {
          showNotification(paste("Échec de copie du fichier:", input$upload_rapport$name[i]), type = "error")
          upload_success <- FALSE
        } else {
          file_url <- file.path("documents", activity_num, new_filename)
          
          rapport_info <- list(
            name = input$upload_rapport$name[i],
            filename = new_filename,
            filepath = new_filepath,
            file_url = file_url,
            size = input$upload_rapport$size[i],
            type = input$upload_rapport$type[i],
            upload_time = Sys.time()
          )
          docs[[activity_num]]$rapports[[length(docs[[activity_num]]$rapports) + 1]] <- rapport_info
          rapport_count <- rapport_count + 1
        }
      }
    }
    
    # Upload des images
    if (!is.null(input$upload_images)) {
      for (i in 1:nrow(input$upload_images)) {
        file_ext <- tools::file_ext(input$upload_images$name[i])
        timestamp <- format(Sys.time(), "%Y%m%d%H%M%S")
        new_filename <- paste0("image_", timestamp, "_", i, ".", file_ext)
        new_filepath <- file.path(activity_dir, new_filename)
        
        ok <- file.copy(input$upload_images$datapath[i], new_filepath, overwrite = TRUE)
        
        if (!ok) {
          showNotification(paste("Échec de copie de l'image:", input$upload_images$name[i]), type = "error")
          upload_success <- FALSE
        } else {
          file_url <- file.path("documents", activity_num, new_filename)
          
          image_info <- list(
            name = input$upload_images$name[i],
            filename = new_filename,
            filepath = new_filepath,
            file_url = file_url,
            size = input$upload_images$size[i],
            type = input$upload_images$type[i],
            upload_time = Sys.time()
          )
          docs[[activity_num]]$images[[length(docs[[activity_num]]$images) + 1]] <- image_info
          image_count <- image_count + 1
        }
      }
    }
    
    documents_activites(docs)
    
    showNotification(
      paste("Upload terminé:", rapport_count, "rapport(s),", image_count, "image(s)"), 
      type = if(upload_success) "message" else "warning"
    )
    
    shinyjs::reset("upload_rapport")
    shinyjs::reset("upload_images")
  })
  
  # Liste des rapports avec recherche
  output$rapports_list <- renderUI({
    req(input$activite_documents)
    
    activity_num <- as.character(as.numeric(input$activite_documents))
    docs <- documents_activites()
    
    if (is.null(docs[[activity_num]]) || length(docs[[activity_num]]$rapports) == 0) {
      return(div(class = "alert alert-info",
                 icon("info-circle"),
                 "Aucun rapport disponible pour cette activité"))
    }
    
    rapports <- docs[[activity_num]]$rapports
    
    # Filtrer par recherche
    if (!is.null(input$search_docs) && input$search_docs != "") {
      rapports <- rapports[grepl(input$search_docs, sapply(rapports, function(x) x$name), ignore.case = TRUE)]
    }
    
    if (length(rapports) == 0) {
      return(div(class = "alert alert-warning", "Aucun rapport correspondant à votre recherche"))
    }
    
    rapport_items <- lapply(seq_along(rapports), function(i) {
      r <- rapports[[i]]
      file_ext <- tolower(tools::file_ext(r$filepath))
      
      file_icon <- if(file_ext == "pdf") "file-pdf" else "file-alt"
      
      div(class = "rapport-item",
          div(style = "flex: 1;",
              div(icon(file_icon), 
                  strong(r$name),
                  style = "font-size: 1.1rem; margin-bottom: 5px;"),
              div(paste0(round(r$size / 1024, 1), " KB"), 
                  style = "color: #6c757d; font-size: 0.85rem;"),
              div(format(r$upload_time, "%d/%m/%Y %H:%M"), 
                  style = "color: #6c757d; font-size: 0.8rem;")
          ),
          div(
            if(file_ext == "pdf") {
              tags$a(href = r$file_url, target = "_blank",
                     class = "btn btn-info btn-sm",
                     style = "margin-right: 5px;",
                     icon("book-open"), "Lire")
            } else if(file_ext == "txt") {
              actionButton(inputId = paste0("view_txt_", activity_num, "_", i),
                           label = "Lire",
                           icon = icon("book-open"),
                           class = "btn-info btn-sm",
                           style = "margin-right: 5px;",
                           onclick = sprintf("Shiny.setInputValue('view_txt', {activity: '%s', index: %d}, {priority: 'event'})", 
                                             activity_num, i))
            },
            actionButton(inputId = paste0("delete_rapport_", activity_num, "_", i),
                         label = NULL,
                         icon = icon("trash"),
                         class = "btn-danger btn-sm",
                         onclick = sprintf("Shiny.setInputValue('delete_rapport', {activity: '%s', index: %d}, {priority: 'event'})", 
                                           activity_num, i))
          )
      )
    })
    
    div(rapport_items)
  })
  
  # Recherche de documents
  output$search_results <- renderUI({
    req(input$activite_documents)
    
    activity_num <- as.character(as.numeric(input$activite_documents))
    docs <- documents_activites()
    
    if (is.null(docs[[activity_num]])) {
      return(div(class = "alert alert-info", "Aucun document disponible"))
    }
    
    search_term <- input$search_docs
    if (is.null(search_term) || search_term == "") {
      return(div(class = "alert alert-info", "Entrez un terme de recherche"))
    }
    
    results <- list()
    
    # Recherche dans les rapports
    if (!is.null(docs[[activity_num]]$rapports)) {
      for (r in docs[[activity_num]]$rapports) {
        if (grepl(search_term, r$name, ignore.case = TRUE)) {
          results <- c(results, div(icon("file-pdf"), " Rapport: ", strong(r$name)))
        }
      }
    }
    
    # Recherche dans les images
    if (!is.null(docs[[activity_num]]$images)) {
      for (img in docs[[activity_num]]$images) {
        if (grepl(search_term, img$name, ignore.case = TRUE)) {
          results <- c(results, div(icon("image"), " Image: ", strong(img$name)))
        }
      }
    }
    
    if (length(results) == 0) {
      return(div(class = "alert alert-warning", "Aucun résultat trouvé"))
    }
    
    div(
      h5(paste(length(results), "résultat(s) trouvé(s)")),
      hr(),
      results
    )
  })
  
  # Visualisation des fichiers texte
  observeEvent(input$view_txt, {
    req(input$view_txt)
    
    doc_info <- input$view_txt
    docs <- documents_activites()
    
    if (!is.null(docs[[doc_info$activity]]) && 
        !is.null(docs[[doc_info$activity]]$rapports[[as.numeric(doc_info$index)]])) {
      
      rapport <- docs[[doc_info$activity]]$rapports[[as.numeric(doc_info$index)]]
      
      content <- tryCatch({
        readLines(rapport$filepath, warn = FALSE, encoding = "UTF-8")
      }, error = function(e) {
        readLines(rapport$filepath, warn = FALSE)
      })
      
      showModal(modalDialog(
        title = div(icon("file-alt"), " ", rapport$name),
        div(class = "text-preview",
            pre(paste(content, collapse = "\n"))
        ),
        footer = tagList(
          downloadButton(paste0("download_rapport_modal_", doc_info$activity, "_", doc_info$index),
                         "Télécharger", class = "btn-success"),
          modalButton("Fermer")
        ),
        size = "l",
        easyClose = TRUE
      ))
    }
  })
  
  # Galerie d'images avec recherche
  output$image_gallery <- renderUI({
    req(input$activite_documents)
    
    activity_num <- as.character(as.numeric(input$activite_documents))
    docs <- documents_activites()
    
    if (is.null(docs[[activity_num]]) || length(docs[[activity_num]]$images) == 0) {
      return(div(class = "alert alert-info",
                 icon("info-circle"),
                 "Aucune image disponible pour cette activité"))
    }
    
    images <- docs[[activity_num]]$images
    
    # Filtrer par recherche
    if (!is.null(input$search_docs) && input$search_docs != "") {
      images <- images[grepl(input$search_docs, sapply(images, function(x) x$name), ignore.case = TRUE)]
    }
    
    if (length(images) == 0) {
      return(div(class = "alert alert-warning", "Aucune image correspondant à votre recherche"))
    }
    
    image_tags <- lapply(seq_along(images), function(i) {
      img_info <- images[[i]]
      
      div(class = "image-item",
          tags$a(href = img_info$file_url, target = "_blank",
                 img(src = img_info$file_url,
                     alt = img_info$name,
                     style = "width: 100%; height: 150px; object-fit: cover;")),
          div(class = "image-caption",
              strong(ifelse(nchar(img_info$name) > 20, 
                            paste0(substr(img_info$name, 1, 20), "..."), 
                            img_info$name)),
              br(),
              paste0(round(img_info$size / 1024, 1), " KB")
          ),
          actionButton(inputId = paste0("delete_img_", activity_num, "_", i),
                       label = NULL,
                       icon = icon("trash"),
                       class = "delete-image",
                       onclick = sprintf("Shiny.setInputValue('delete_image', {activity: '%s', index: %d}, {priority: 'event'})", 
                                         activity_num, i))
      )
    })
    
    div(class = "image-gallery", image_tags)
  })
  
  # Générateurs de téléchargement
  observe({
    docs <- documents_activites()
    
    for (activity_num in names(docs)) {
      if (!is.null(docs[[activity_num]]$rapports)) {
        for (i in seq_along(docs[[activity_num]]$rapports)) {
          local({
            act_num <- activity_num
            idx <- i
            rapport <- docs[[act_num]]$rapports[[idx]]
            
            output[[paste0("download_rapport_modal_", act_num, "_", idx)]] <- downloadHandler(
              filename = function() { rapport$name },
              content = function(file) { file.copy(rapport$filepath, file, overwrite = TRUE) }
            )
          })
        }
      }
    }
  })
  
  # Supprimer un rapport
  observeEvent(input$delete_rapport, {
    req(input$delete_rapport)
    
    docs <- documents_activites()
    del_info <- input$delete_rapport
    
    if (!is.null(docs[[del_info$activity]]) && 
        !is.null(docs[[del_info$activity]]$rapports[[as.numeric(del_info$index)]])) {
      
      rapport <- docs[[del_info$activity]]$rapports[[as.numeric(del_info$index)]]
      if (file.exists(rapport$filepath)) file.remove(rapport$filepath)
      
      docs[[del_info$activity]]$rapports[[as.numeric(del_info$index)]] <- NULL
      documents_activites(docs)
      
      showNotification("Rapport supprimé avec succès!", type = "message")
    }
  })
  
  # Supprimer une image
  observeEvent(input$delete_image, {
    req(input$delete_image)
    
    docs <- documents_activites()
    del_info <- input$delete_image
    
    if (!is.null(docs[[del_info$activity]]) && 
        !is.null(docs[[del_info$activity]]$images[[as.numeric(del_info$index)]])) {
      
      image <- docs[[del_info$activity]]$images[[as.numeric(del_info$index)]]
      if (file.exists(image$filepath)) file.remove(image$filepath)
      
      docs[[del_info$activity]]$images[[as.numeric(del_info$index)]] <- NULL
      documents_activites(docs)
      
      showNotification("Image supprimée avec succès!", type = "message")
    }
  })
  
  # Fonctions pour la gestion des activités
  get_next_activity_number <- function() {
    data <- activites()
    if (nrow(data) == 0) return(1)
    max(data$Num_Activite) + 1
  }
  
  observeEvent(input$vider_formulaire, {
    updateNumericInput(session, "num_activite", value = get_next_activity_number())
    updateTextInput(session, "nom_activite", value = "")
    updateTextInput(session, "responsable", value = "")
    updateNumericInput(session, "nb_taches", value = 1)
    updateNumericInput(session, "taches_completees", value = 0)
    updateNumericInput(session, "budget_alloue_prevu", value = 0)
    updateNumericInput(session, "budget_alloue_reel", value = 0)
    updateTextAreaInput(session, "description", value = "")
    updateDateRangeInput(session, "periode_prevue", start = Sys.Date(), end = Sys.Date() + 7)
    updateDateRangeInput(session, "periode_reelle", start = NULL, end = NULL)
    selected_activity(NULL)
  })
  
  observeEvent(input$tableau_base_donnees_rows_selected, {
    if (length(input$tableau_base_donnees_rows_selected) > 0) {
      data <- activites()
      selected_row <- input$tableau_base_donnees_rows_selected
      selected_activity(data[selected_row, ])
      clicked_activity(data[selected_row, ])
      
      updateNumericInput(session, "num_activite", value = data$Num_Activite[selected_row])
      updateTextInput(session, "nom_activite", value = data$Nom_Activite[selected_row])
      updateTextInput(session, "responsable", value = data$Responsable[selected_row])
      updateSelectInput(session, "priorite", selected = data$Priorite[selected_row])
      updateNumericInput(session, "nb_taches", value = data$Nb_Taches[selected_row])
      updateNumericInput(session, "taches_completees", value = data$Taches_Completees[selected_row])
      updateNumericInput(session, "budget_alloue_prevu", value = data$Budget_Prevue[selected_row])
      updateNumericInput(session, "budget_alloue_reel", value = data$Budget_Reel[selected_row])
      updateTextAreaInput(session, "description", value = data$Description[selected_row])
      updateDateRangeInput(session, "periode_prevue", start = data$Date_Debut_Prevue[selected_row], end = data$Date_Fin_Prevue[selected_row])
      updateDateRangeInput(session, "periode_reelle", 
                           start = if(!is.na(data$Date_Debut_Reelle[selected_row])) data$Date_Debut_Reelle[selected_row] else NULL,
                           end = if(!is.na(data$Date_Fin_Reelle[selected_row])) data$Date_Fin_Reelle[selected_row] else NULL)
    }
  })
  
  observeEvent(input$ajouter_activite, {
    if (input$nom_activite == "") {
      showNotification("Veuillez saisir un nom pour l'activité!", type = "error")
      return()
    }
    if (input$responsable == "") {
      showNotification("Veuillez saisir un nom de responsable!", type = "error")
      return()
    }
    
    data <- activites()
    if (input$num_activite %in% data$Num_Activite) {
      showNotification("Ce numéro d'activité existe déjà!", type = "error")
      return()
    }
    
    taches_comp <- min(input$taches_completees, input$nb_taches)
    status <- ifelse(taches_comp == 0, "Non démarrée",
                     ifelse(taches_comp == input$nb_taches, "Terminée", "En cours"))
    
    new_activity <- data.frame(
      Num_Activite = input$num_activite,
      Nom_Activite = input$nom_activite,
      Responsable = input$responsable,
      Priorite = input$priorite,
      Nb_Taches = input$nb_taches,
      Taches_Completees = taches_comp,
      Budget_Prevue = input$budget_alloue_prevu,
      Budget_Reel = input$budget_alloue_reel,
      Description = input$description,
      Statut = status,
      Date_Debut_Prevue = input$periode_prevue[1],
      Date_Fin_Prevue = input$periode_prevue[2],
      Date_Debut_Reelle = if(!is.null(input$periode_reelle[1])) input$periode_reelle[1] else as.Date(NA),
      Date_Fin_Reelle = if(!is.null(input$periode_reelle[2])) input$periode_reelle[2] else as.Date(NA),
      stringsAsFactors = FALSE
    )
    
    activites(rbind(activites(), new_activity))
    filtered_data(activites())
    
    updateNumericInput(session, "num_activite", value = get_next_activity_number())
    updateTextInput(session, "nom_activite", value = "")
    updateTextInput(session, "responsable", value = "")
    updateNumericInput(session, "nb_taches", value = 1)
    updateNumericInput(session, "taches_completees", value = 0)
    updateNumericInput(session, "budget_alloue_prevu", value = 0)
    updateNumericInput(session, "budget_alloue_reel", value = 0)
    updateTextAreaInput(session, "description", value = "")
    updateDateRangeInput(session, "periode_prevue", start = Sys.Date(), end = Sys.Date() + 7)
    updateDateRangeInput(session, "periode_reelle", start = NULL, end = NULL)
    
    showNotification("Activité ajoutée avec succès!", type = "message")
  })
  
  observeEvent(input$modifier_activite, {
    if (is.null(selected_activity())) {
      showNotification("Veuillez sélectionner une activité à modifier!", type = "error")
      return()
    }
    if (input$nom_activite == "") {
      showNotification("Veuillez saisir un nom pour l'activité!", type = "error")
      return()
    }
    if (input$responsable == "") {
      showNotification("Veuillez saisir un nom de responsable!", type = "error")
      return()
    }
    
    data <- activites()
    selected_row <- which(data$Num_Activite == selected_activity()$Num_Activite)
    
    if (length(selected_row) == 0) {
      showNotification("Activité non trouvée!", type = "error")
      return()
    }
    
    taches_comp <- min(input$taches_completees, input$nb_taches)
    status <- ifelse(taches_comp == 0, "Non démarrée",
                     ifelse(taches_comp == input$nb_taches, "Terminée", "En cours"))
    
    data[selected_row, ] <- data.frame(
      Num_Activite = input$num_activite,
      Nom_Activite = input$nom_activite,
      Responsable = input$responsable,
      Priorite = input$priorite,
      Nb_Taches = input$nb_taches,
      Taches_Completees = taches_comp,
      Budget_Prevue = input$budget_alloue_prevu,
      Budget_Reel = input$budget_alloue_reel,
      Description = input$description,
      Statut = status,
      Date_Debut_Prevue = input$periode_prevue[1],
      Date_Fin_Prevue = input$periode_prevue[2],
      Date_Debut_Reelle = if(!is.null(input$periode_reelle[1])) input$periode_reelle[1] else as.Date(NA),
      Date_Fin_Reelle = if(!is.null(input$periode_reelle[2])) input$periode_reelle[2] else as.Date(NA),
      stringsAsFactors = FALSE
    )
    
    activites(data)
    filtered_data(data)
    selected_activity(NULL)
    
    showNotification("Activité modifiée avec succès!", type = "message")
  })
  
  observeEvent(input$supprimer_activite, {
    if (is.null(selected_activity())) {
      showNotification("Veuillez sélectionner une activité à supprimer!", type = "error")
      return()
    }
    
    showModal(modalDialog(
      title = "Confirmation de suppression",
      paste("Êtes-vous sûr de vouloir supprimer l'activité :", selected_activity()$Nom_Activite, "?"),
      footer = tagList(
        actionButton("confirm_delete", "Oui, supprimer", class = "btn-danger"),
        modalButton("Annuler")
      )
    ))
  })
  
  observeEvent(input$confirm_delete, {
    data <- activites()
    selected_row <- which(data$Num_Activite == selected_activity()$Num_Activite)
    
    if (length(selected_row) > 0) {
      docs <- documents_activites()
      activity_num <- as.character(data$Num_Activite[selected_row])
      if (!is.null(docs[[activity_num]])) {
        activity_dir <- file.path(upload_dir, activity_num)
        if (dir.exists(activity_dir)) unlink(activity_dir, recursive = TRUE)
        docs[[activity_num]] <- NULL
        documents_activites(docs)
      }
      
      data <- data[-selected_row, ]
      activites(data)
      filtered_data(data)
      selected_activity(NULL)
      
      updateNumericInput(session, "num_activite", value = get_next_activity_number())
      updateTextInput(session, "nom_activite", value = "")
      updateTextInput(session, "responsable", value = "")
      updateNumericInput(session, "nb_taches", value = 1)
      updateNumericInput(session, "taches_completees", value = 0)
      updateNumericInput(session, "budget_alloue_prevu", value = 0)
      updateNumericInput(session, "budget_alloue_reel", value = 0)
      updateTextAreaInput(session, "description", value = "")
      updateDateRangeInput(session, "periode_prevue", start = Sys.Date(), end = Sys.Date() + 7)
      updateDateRangeInput(session, "periode_reelle", start = NULL, end = NULL)
      
      showNotification("Activité supprimée avec succès!", type = "message")
    }
    
    removeModal()
  })
  
  observeEvent(input$appliquer_filtres, {
    data <- activites()
    if (input$periode_type == "global") {
      filtered_data(data)
    } else {
      annee <- as.numeric(input$periode_annee)
      periode_specifique <- if (input$periode_type %in% c("mensuel", "trimestriel", "semestriel")) input$periode_specifique else NULL
      
      filtered <- data %>%
        mutate(Date_Filtre = coalesce(Date_Debut_Reelle, Date_Debut_Prevue)) %>%
        filter(year(Date_Filtre) == annee)
      
      if (input$periode_type == "mensuel" && !is.null(periode_specifique)) {
        filtered <- filtered %>% filter(month(Date_Filtre) == as.numeric(periode_specifique))
      } else if (input$periode_type == "trimestriel" && !is.null(periode_specifique)) {
        filtered <- filtered %>% filter(quarter(Date_Filtre) == as.numeric(periode_specifique))
      } else if (input$periode_type == "semestriel" && !is.null(periode_specifique)) {
        semestre <- as.numeric(periode_specifique)
        filtered <- filtered %>% filter(if(semestre == 1) month(Date_Filtre) <= 6 else month(Date_Filtre) > 6)
      }
      
      filtered_data(filtered %>% select(-Date_Filtre))
    }
    filters_applied(TRUE)
    showNotification("Filtres appliqués avec succès!", type = "message")
  })
  
  observeEvent(input$reset_filtres, {
    filtered_data(activites())
    filters_applied(FALSE)
    updateSelectInput(session, "periode_type", selected = "global")
    showNotification("Filtres réinitialisés!", type = "message")
  })
  
  dashboard_data <- reactive({
    if (filters_applied()) filtered_data() else activites()
  })
  
  output$total_activites_value <- renderText({ nrow(dashboard_data()) })
  output$activites_terminees_value <- renderText({ sum(dashboard_data()$Statut == "Terminée", na.rm = TRUE) })
  
  output$taux_realisation_budget_value <- renderText({
    df <- dashboard_data()
    if (nrow(df) == 0) return("0%")
    budget_total_prevu <- sum(df$Budget_Prevue, na.rm = TRUE)
    if (budget_total_prevu == 0) return("0%")
    paste0(round((sum(df$Budget_Reel, na.rm = TRUE) / budget_total_prevu) * 100, 1), "%")
  })
  
  output$taux_avancement_value <- renderText({
    df <- dashboard_data()
    if (nrow(df) == 0) return("0%")
    paste0(round(mean(ifelse(df$Nb_Taches > 0, (df$Taches_Completees / df$Nb_Taches) * 100, 0), na.rm = TRUE), 1), "%")
  })
  
  output$status_plot <- renderPlot({
    data <- dashboard_data()
    if (nrow(data) == 0) return(ggplot() + annotate("text", x = 1, y = 1, label = "Aucune donnée disponible", size = 6) + theme_void())
    
    status_counts <- data %>%
      filter(!is.na(Statut)) %>%
      count(Statut) %>%
      mutate(Statut = factor(Statut, levels = c("Non démarrée", "En cours", "Terminée")))
    
    ggplot(status_counts, aes(x = Statut, y = n, fill = Statut)) +
      geom_col(show.legend = FALSE) +
      geom_text(aes(label = n), vjust = 1.5, size = 6, color = "white", fontface = "bold") +
      scale_fill_manual(values = c("Non démarrée" = "#EF4444", "En cours" = "#F59E0B", "Terminée" = "#10B981")) +
      labs(x = "Statut", y = "Nombre") + 
      theme_minimal() +
      theme(axis.text = element_text(size = 12), 
            axis.title = element_text(size = 14),
            panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank())
  })
  
  output$priority_plot <- renderPlot({
    data <- dashboard_data()
    if (nrow(data) == 0) return(ggplot() + annotate("text", x = 1, y = 1, label = "Aucune donnée disponible", size = 6) + theme_void())
    
    priority_counts <- data %>%
      filter(!is.na(Priorite)) %>%
      count(Priorite) %>%
      mutate(Priorite = factor(Priorite, levels = c("Faible", "Moyenne", "Élevée", "Critique")),
             percentage = n / sum(n) * 100,
             ypos = cumsum(n) - 0.5 * n)
    
    ggplot(priority_counts, aes(x = "", y = n, fill = Priorite)) +
      geom_bar(stat = "identity", width = 1) +
      geom_text(aes(y = ypos, label = paste0(n, "\n(", round(percentage, 1), "%)")), 
                color = "white", size = 5, fontface = "bold") +
      coord_polar("y", start = 0) +
      scale_fill_manual(values = c("Faible" = "#10B981", "Moyenne" = "#3B82F6", 
                                   "Élevée" = "#F59E0B", "Critique" = "#EF4444")) +
      labs(fill = "Priorité") + 
      theme_void() +
      theme(legend.position = "bottom", 
            legend.text = element_text(size = 12), 
            legend.title = element_text(size = 14))
  })
  
  # Graphique des responsables avec hauteur dynamique et axe des ordonnées
  output$responsable_plot <- renderPlot({
    data <- dashboard_data()
    if (nrow(data) == 0) {
      return(ggplot() + 
               annotate("text", x = 1, y = 1, label = "Aucune donnée disponible", size = 6) + 
               theme_void())
    }
    
    responsable_counts <- data %>%
      filter(!is.na(Responsable)) %>%
      count(Responsable) %>%
      arrange(desc(n))
    
    # Créer le graphique
    p <- ggplot(responsable_counts, aes(x = reorder(Responsable, n), y = n, fill = Responsable)) +
      geom_col(show.legend = FALSE, width = 0.7) +
      geom_text(aes(label = n), hjust = -0.2, size = 4.5, color = "black", fontface = "bold") +
      scale_fill_viridis_d() +
      labs(x = "Responsable", y = "Nombre d'activités") +
      coord_flip() + 
      theme_minimal() +
      theme(
        axis.text = element_text(size = 11),
        axis.title = element_text(size = 13, face = "bold"),
        axis.title.y = element_text(size = 13, face = "bold", margin = margin(r = 10)),
        axis.title.x = element_text(size = 13, face = "bold", margin = margin(t = 10)),
        panel.grid.major = element_line(color = "#e0e0e0", linewidth = 0.5),
        panel.grid.minor = element_blank(),
        plot.margin = margin(10, 30, 10, 10)
      ) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.15)))
    
    print(p)
    
  }, height = function() responsable_plot_height())
  
  output$progress_gauge <- renderUI({
    data <- dashboard_data()
    if (nrow(data) == 0) {
      return(div(class = "alert alert-info", icon("info-circle"),
                 "Aucune donnée disponible pour afficher la progression"))
    }
    
    progress_data <- data %>%
      mutate(
        progression = ifelse(Nb_Taches > 0, round((Taches_Completees / Nb_Taches) * 100, 1), 0),
        nom_court = ifelse(nchar(Nom_Activite) > 30, 
                           paste0(substr(Nom_Activite, 1, 27), "..."), 
                           Nom_Activite)
      ) %>%
      arrange(desc(progression))
    
    progress_bars <- lapply(1:nrow(progress_data), function(i) {
      act <- progress_data[i, ]
      
      progress_class <- if(act$progression == 0) "progress-0" else 
        if(act$progression < 25) "progress-25" else 
          if(act$progression < 50) "progress-50" else 
            if(act$progression < 75) "progress-75" else 
              "progress-100"
      
      div(class = "progress-bar-container",
          div(class = "progress-bar-label",
              span(class = "activity-name", act$nom_court),
              span(class = "progress-value", paste0(act$progression, "%"))
          ),
          div(class = "custom-progress",
              div(class = paste("custom-progress-bar", progress_class),
                  style = paste0("width: ", act$progression, "%"),
                  if(act$progression > 10) paste0(act$progression, "%") else "")
          ),
          div(style = "display: flex; justify-content: space-between; margin-top: 5px; font-size: 0.8rem; color: #6c757d;",
              span(paste("Tâches:", act$Taches_Completees, "/", act$Nb_Taches)),
              span(paste("Responsable:", act$Responsable))
          )
      )
    })
    
    div(class = "gauge-container",
        div(class = "gauge-title", "Progression des activités"),
        div(style = "padding-right: 10px;",
            progress_bars
        )
    )
  })
  
  output$tableau_base_donnees <- renderDT({
    data <- activites()
    if (nrow(data) == 0) {
      return(datatable(data.frame(Message = "Aucune donnée disponible"), 
                       options = list(dom = 't'), rownames = FALSE))
    }
    
    display_data <- data %>%
      mutate(
        Progression = ifelse(Nb_Taches > 0, paste0(round((Taches_Completees / Nb_Taches) * 100, 1), "%"), "0%"),
        Budget_Prevue = format(round(Budget_Prevue, 0), big.mark=" "),
        Budget_Reel = format(round(Budget_Reel, 0), big.mark=" "),
        Date_Debut_Prevue = format(Date_Debut_Prevue, "%d/%m/%Y"),
        Date_Fin_Prevue = format(Date_Fin_Prevue, "%d/%m/%Y"),
        Date_Debut_Reelle = ifelse(is.na(Date_Debut_Reelle), "-", format(Date_Debut_Reelle, "%d/%m/%Y")),
        Date_Fin_Reelle = ifelse(is.na(Date_Fin_Reelle), "-", format(Date_Fin_Reelle, "%d/%m/%Y"))
      ) %>%
      select(Num_Activite, Nom_Activite, Responsable, Priorite, Statut, Progression, 
             Budget_Prevue, Budget_Reel, everything())
    
    datatable(display_data,
              options = list(pageLength = 10, scrollX = TRUE,
                             language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/French.json')),
              selection = 'single', rownames = FALSE)
  })
  
  output$export_data <- downloadHandler(
    filename = function() { paste("activites-ong-", Sys.Date(), ".csv", sep = "") },
    content = function(file) {
      indices_filtres <- input$tableau_base_donnees_rows_all
      data_complete <- activites()
      data_to_export <- if (is.null(indices_filtres) || length(indices_filtres) == 0) data_complete else data_complete[indices_filtres, ]
      write.csv(data_to_export, file, row.names = FALSE, fileEncoding = "UTF-8")
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)