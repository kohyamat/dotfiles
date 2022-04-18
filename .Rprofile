# CRAN mirror --------------------------------------
options(repos = c("https://cran.ism.ac.jp/", "http://cloud.r-project.org/"))

# Nvim-R -------------------------------------------
if (interactive() &&
  Sys.info()[["sysname"]] == "Linux" &&
  Sys.getenv("DISPLAY") == "") {
  if (Sys.getenv("TMUX") != "") {
    options(browser = function(u) system(paste0("tmux new-window 'w3m ", u, "'")))
  } else if (Sys.getenv("NVIMR_TMPDIR") != "") {
    options(browser = function(u) {
      .C(
        "nvimcom_msg_to_nvim",
        paste0('StartTxtBrowser("w3m", "', u, '")')
      )
    })
  }
}

if (any(grepl("colorout", utils::installed.packages()))) {
  library(colorout)
  setOutputColors256(
    normal = 7, negnum = 3, zero = 3, number = 3,
    date = 3, string = 6, const = 1, false = 1,
    true = 1, infinite = 2, stderror = 4,
    warn = c(1, 0, 5), error = c(1, 4, 236),
    verbose = FALSE, zero.limit = NA
  )
}


# Japanese environments ----------------------------
if (Sys.info()[["sysname"]] == "Darwin") {
  setHook(
    packageEvent("grDevices", "onLoad"),
    function(...) grDevices::pdf.options(family = "Japan1GothicBBB")
  )
  setHook(
    packageEvent("grDevices", "onLoad"),
    function(...) grDevices::ps.options(family = "Japan1GothicBBB")
  )
  setHook(
    packageEvent("grDevices", "onLoad"),
    function(...) {
      grDevices::quartzFonts(serif = grDevices::quartzFont(
        c(
          "Hiragino Mincho ProN W3",
          "Hiragino Mincho ProN W6",
          "Hiragino Mincho ProN W3",
          "Hiragino Mincho ProN W6"
        )
      ))
      grDevices::quartzFonts(sans = grDevices::quartzFont(
        c(
          "Hiragino Kaku Gothic ProN W3",
          "Hiragino Kaku Gothic ProN W6",
          "Hiragino Kaku Gothic ProN W3",
          "Hiragino Kaku Gothic ProN W6"
        )
      ))
      # grDevices::quartz.options(family="sans")
    }
  )

  attach(NULL, name = "MacJapanEnv")
  assign("familyset_hook",
    function() {
      if (names(dev.cur()) == "quartz") par(family = "sans")
    },
    pos = "MacJapanEnv"
  )
  setHook("plot.new", get("familyset_hook", pos = "MacJapanEnv"))

  options(X11fonts = c(
    "-alias-gothic-%s-%s-*-*-%d-*-*-*-*-*-*-*",
    "-adobe-symbol-*-*-*-*-%d-*-*-*-*-*-*-*"
  ))
}
