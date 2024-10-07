file(REMOVE_RECURSE
  "H2OApp/Chart.qml"
  "H2OApp/ItemPlot.qml"
  "H2OApp/Main.qml"
  "H2OApp/Plot.qml"
  "H2OApp/img/Compressed.png"
  "H2OApp/img/back.png"
  "H2OApp/img/liquid-vapor.png"
  "H2OApp/img/molecule.png"
  "H2OApp/img/saturation_Point.png"
  "H2OApp/img/scatter-graph.png"
  "H2OApp/img/vapor.png"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/appH2OApp_tooling.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
