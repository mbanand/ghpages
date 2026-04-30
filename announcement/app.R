# Store this file next to app.css and app.js.

library(shiny)
library(shiny.webawesome)
library(htmltools)

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

species_choices <- c(
  "All species" = "all",
  "Setosa" = "setosa",
  "Versicolor" = "versicolor",
  "Virginica" = "virginica"
)

variable_choices <- c(
  "Sepal length" = "Sepal.Length",
  "Sepal width" = "Sepal.Width",
  "Petal length" = "Petal.Length",
  "Petal width" = "Petal.Width"
)

select_choices <- function(id, label, value, choices) {
  do.call(
    wa_select,
    c(
      list(id, label = label, value = value),
      lapply(names(choices), function(name) {
        wa_option(name, value = choices[[name]])
      })
    )
  )
}

stat_card <- function(label, output_id) {
  wa_container(
    class = "stat-card",
    wa_container(
      class = "wa-stack wa-gap-3xs",
      style = "padding: 0;",
      span(class = "stat-label", label),
      span(class = "stat-value", textOutput(output_id, inline = TRUE))
    )
  )
}

if (!exists("css_text", inherits = FALSE) || !exists("js_text", inherits = FALSE)) {
  app_dir <- tryCatch(
    dirname(normalizePath(sys.frame(1)$ofile)),
    error = function(e) getwd()
  )

  css_text <- paste(readLines(file.path(app_dir, "app.css"), warn = FALSE), collapse = "\n")
  js_text <- paste(readLines(file.path(app_dir, "app.js"), warn = FALSE), collapse = "\n")
}

show_shinylive_badge <- isTRUE(get0("show_shinylive_badge", ifnotfound = FALSE))

# Build the demo UI.
ui <- webawesomePage(
  title = "Iris Workbench",
  tags$style(HTML(css_text)),
  wa_js(js_text),
  # The drawer acts like a lightweight inspector for the current app state.
  wa_drawer(
    "help_drawer",
    label = "Inspector",
    placement = "end",
    light_dismiss = FALSE,
    wa_container(
      class = "wa-stack wa-gap-m",
      wa_callout(
        variant = "brand",
        appearance = "outlined",
        icon = wa_icon(name = "circle-info"),
        "This example keeps the controls visible and lets each tab react immediately."
      ),
      wa_card(
        header = "Current view",
        wa_container(class = "wa-stack wa-gap-s", uiOutput("inspector_state"))
      ),
      wa_card(
        header = "What this demo shows",
        wa_container(
          class = "wa-stack wa-gap-s",
          p(class = "details-copy", "One control rail drives three presentations of the same filtered state: chart, summary, and explanatory details.")
        )
      ),
      wa_card(
        header = "shiny.webawesome facilities",
        wa_container(
          class = "wa-stack wa-gap-s",
          tags$ul(
            class = "details-copy",
            style = "margin: 0; padding-left: 1.1rem;",
            tags$li("Polished presentation elements with one coherent theme."),
            tags$li("Built-in layout tools for compact app structure."),
            tags$li("Shiny bindings for Web Awesome form and navigation components."),
            tags$li("Package command helpers for browser-side property and method control.")
          )
        )
      )
    )
  ),
  wa_container(
    class = "workbench-shell",
    wa_container(
      class = "workbench-stage",
      # This utility row is only shown in the live article embed.
      if (show_shinylive_badge) {
        wa_container(
          class = "workbench-kicker wa-cluster wa-gap-xs wa-align-items-center",
          wa_badge("Live in the browser", appearance = "accent"),
          span("Powered by Shinylive: A compact iris workbench")
        )
      },
      wa_card(
        class = "title-card",
        wa_container(
          class = "title-stack",
          h2(class = "title-line", "Polished analytics with shiny.webawesome"),
          p(
            class = "title-copy",
            "Use the left rail to change the view. The chart, summary table, and details tab all respond."
          )
        )
      ),
      wa_container(
        class = "workbench-layout",
        # Left rail for filters and small app actions.
        wa_card(
          class = "sidebar-card",
          header = "Controls",
          wa_container(
            class = "sidebar-stack",
            select_choices("species", "Species", "all", species_choices),
            select_choices("x_var", "X variable", "Sepal.Length", variable_choices),
            select_choices("y_var", "Y variable", "Sepal.Width", variable_choices),
            wa_switch("show_smoother", "Show trend line"),
            uiOutput("preset_controls"),
            wa_button(
              "open_help",
              "Open inspector",
              appearance = "accent",
              `data-drawer` = "open help_drawer"
            ),
            p(class = "sidebar-note", textOutput("sidebar_note"))
          )
        ),
        # Main stage for summary badges, tabs, and the live outputs.
        wa_card(
          class = "preview-card",
          wa_container(
            class = "preview-stack",
            wa_container(
              class = "preview-header",
              wa_container(
                class = "wa-cluster wa-gap-xs wa-align-items-center",
                uiOutput("selection_badges")
              ),
              wa_badge(textOutput("tab_badge", inline = TRUE), appearance = "filled")
            ),
            wa_container(
              class = "stats-grid",
              stat_card("Rows", "row_count"),
              stat_card("Correlation", "correlation_value"),
              stat_card("Focus", "focus_value")
            ),
            wa_tab_group(
              class = "workbench-tab-group",
              "surface_tabs",
              active = "chart",
              wa_tab("Chart", panel = "chart"),
              wa_tab("Summary", panel = "summary"),
              wa_tab("Details", panel = "details"),
              wa_tab_panel(
                name = "chart",
                wa_container(
                  class = "tab-stack tab-shell",
                  p(
                    class = "tab-copy",
                    "Change a variable or species on the left and the plot responds immediately."
                  ),
                  wa_container(
                    class = "plot-shell",
                    plotOutput("iris_plot", height = "245px")
                  )
                )
              ),
              wa_tab_panel(
                name = "summary",
                wa_container(
                  class = "tab-stack tab-shell",
                  p(
                    class = "tab-copy",
                    "The summary tab turns the same filtered data into a compact numeric view."
                  ),
                  wa_select(
                    "focus_metric",
                    label = "Summary focus",
                    value = "mean",
                    wa_option("Mean", value = "mean"),
                    wa_option("Median", value = "median"),
                    wa_option("Maximum", value = "max")
                  ),
                  wa_container(
                    class = "table-shell",
                    tableOutput("summary_table")
                  )
                )
              ),
              wa_tab_panel(
                name = "details",
                wa_container(
                  class = "tab-stack tab-shell",
                  p(
                    class = "tab-copy",
                    "The details tab uses expandable sections that explain the views."
                  ),
                  wa_details(
                    "story_details",
                    summary = "What this view is showing",
                    open = TRUE,
                    p(class = "details-copy", textOutput("details_text"))
                  ),
                  wa_details(
                    "change_details",
                    summary = "Settings",
                    p(class = "details-copy", textOutput("filters_text"))
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)

# Server logic keeps the plot, summaries, details, and inspector in sync.
server <- function(input, output, session) {
  current_x_var <- reactive(input$x_var %||% "Sepal.Length")
  current_y_var <- reactive(input$y_var %||% "Sepal.Width")
  trend_enabled <- reactiveVal(FALSE)
  species_label <- reactive({
    species <- input$species %||% "all"
    if (species == "all") "All species" else tools::toTitleCase(species)
  })

  current_preset <- reactive({
    x_var <- current_x_var()
    y_var <- current_y_var()

    if (identical(x_var, "Sepal.Length") && identical(y_var, "Sepal.Width")) {
      "sepal"
    } else if (identical(x_var, "Petal.Length") && identical(y_var, "Petal.Width")) {
      "petal"
    } else {
      NULL
    }
  })

  filtered_data <- reactive({
    if (is.null(input$species) || input$species == "all") {
      iris
    } else {
      iris[tolower(iris$Species) == input$species, , drop = FALSE]
    }
  })

  output$preset_controls <- renderUI({
    wa_container(
      class = "preset-group",
      p(class = "preset-label", "Presets"),
      wa_radio_group(
        "preset_mode",
        class = "preset-radios",
        orientation = "horizontal",
        value = current_preset(),
        wa_radio("Sepal", value = "sepal"),
        wa_radio("Petal", value = "petal")
      )
    )
  })

  observeEvent(input$preset_mode, ignoreNULL = TRUE, ignoreInit = TRUE, {
    if ((input$preset_mode %||% "sepal") == "sepal") {
      update_wa_select(session, "x_var", value = "Sepal.Length")
      update_wa_select(session, "y_var", value = "Sepal.Width")
    } else {
      update_wa_select(session, "x_var", value = "Petal.Length")
      update_wa_select(session, "y_var", value = "Petal.Width")
    }
  })

  observeEvent(input$show_smoother, ignoreInit = TRUE, {
    trend_enabled(input$show_smoother)
  })

  # The badges mirror the current filter and variable choices.
  output$selection_badges <- renderUI({
    tagList(
      wa_badge(species_label(), appearance = "filled"),
      wa_badge(
        sprintf("%s vs %s", current_x_var(), current_y_var()),
        appearance = "filled"
      )
    )
  })

  output$tab_badge <- renderText({
    tools::toTitleCase(input$surface_tabs %||% "chart")
  })

  output$row_count <- renderText(nrow(filtered_data()))

  output$correlation_value <- renderText({
    data <- filtered_data()
    x_var <- current_x_var()
    y_var <- current_y_var()
    sprintf("%.2f", cor(data[[x_var]], data[[y_var]]))
  })

  output$focus_value <- renderText({
    active_tab <- input$surface_tabs %||% "chart"
    if (active_tab == "summary") {
      tools::toTitleCase(input$focus_metric %||% "mean")
    } else if (active_tab == "details") {
      "Details"
    } else {
      if (isTRUE(trend_enabled())) "Trend on" else "Trend off"
    }
  })

  output$sidebar_note <- renderText({
    active_tab <- input$surface_tabs %||% "chart"
    if (active_tab == "chart") {
      "Preset buttons jump between sepal and petal views."
    } else if (active_tab == "summary") {
      "Summary focus changes the statistic."
    } else {
      "Details are tied to the current views and filter state."
    }
  })

  # The chart stays intentionally base-R simple for a copyable standalone app.
  output$iris_plot <- renderPlot({
    data <- filtered_data()
    x_var <- current_x_var()
    y_var <- current_y_var()
    species <- as.character(data$Species)
    species_levels <- unique(species)
    palette <- c(setosa = "#2563eb", versicolor = "#ea580c", virginica = "#059669")
    point_colors <- unname(palette[tolower(species)])
    point_colors[is.na(point_colors)] <- "#475569"

    graphics::par(
      mar = c(4.2, 4.2, 1.2, 0.8),
      bg = "white",
      col.axis = "#334155",
      col.lab = "#0f172a"
    )

    graphics::plot(
      data[[x_var]],
      data[[y_var]],
      col = grDevices::adjustcolor(point_colors, alpha.f = 0.82),
      pch = 19,
      cex = 1.15,
      xlab = x_var,
      ylab = y_var
    )

    if (isTRUE(trend_enabled()) && nrow(data) > 1) {
      fit <- stats::lm(data[[y_var]] ~ data[[x_var]])
      graphics::abline(fit, col = "#1d4ed8", lwd = 2)
    }

    legend_colors <- unname(palette[tolower(species_levels)])
    legend_colors[is.na(legend_colors)] <- "#475569"

    graphics::legend(
      "top",
      inset = 0.02,
      horiz = TRUE,
      bty = "n",
      legend = tools::toTitleCase(species_levels),
      col = legend_colors,
      pch = 19,
      pt.cex = 1
    )
  })

  output$summary_table <- renderTable({
    data <- filtered_data()
    focus <- input$focus_metric %||% "mean"
    x_var <- current_x_var()
    y_var <- current_y_var()

    stat_fn <- switch(focus, mean = mean, median = median, max = max)

    summary_df <- data.frame(
      measure = c(x_var, y_var),
      value = c(round(stat_fn(data[[x_var]]), 2), round(stat_fn(data[[y_var]]), 2)),
      stringsAsFactors = FALSE
    )

    names(summary_df) <- c("Measure", tools::toTitleCase(focus))
    summary_df
  }, striped = TRUE, bordered = FALSE, width = "100%", rownames = FALSE)

  # The details tab turns the current state into plain-language explanation.
  output$details_text <- renderText({
    x_var <- current_x_var()
    y_var <- current_y_var()
    data <- filtered_data()

    paste("The current view compares", x_var, "against", y_var, "for", nrow(data), "rows.")
  })

  output$filters_text <- renderText({
    paste(
      "Species filter:", species_label(), ".",
      "X variable:", current_x_var(), ".",
      "Y variable:", current_y_var(), ".",
      if (isTRUE(trend_enabled())) "Trend line: on." else "Trend line: off."
    )
  })

  output$inspector_state <- renderUI({
    wa_container(
      class = "wa-stack wa-gap-s",
      wa_badge(paste("Tab:", tools::toTitleCase(input$surface_tabs %||% "chart")), appearance = "filled"),
      wa_badge(paste("Species:", species_label()), appearance = "filled"),
      wa_badge(paste("X:", current_x_var()), appearance = "filled"),
      wa_badge(paste("Y:", current_y_var()), appearance = "filled")
    )
  })

  outputOptions(output, "summary_table", suspendWhenHidden = FALSE)
  outputOptions(output, "details_text", suspendWhenHidden = FALSE)
  outputOptions(output, "filters_text", suspendWhenHidden = FALSE)
  outputOptions(output, "inspector_state", suspendWhenHidden = FALSE)
}

shinyApp(ui, server)
