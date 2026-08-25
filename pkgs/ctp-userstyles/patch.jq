def setvar($want):
  if (.options // [] | map(.name) | index($want)) != null
  then .value = $want | .default = $want
  else . end;

def markdefaults:
  split("\n")
  | map(
      if test("^@var[ \t]+select[ \t]+(lightFlavor|darkFlavor)[ \t]") then
        gsub("\\*\"";"\"") | gsub("(?<a>mocha:[^\"*]*)\"";"\(.a)*\"")
      elif test("^@var[ \t]+select[ \t]+accentColor[ \t]") then
        gsub("\\*\"";"\"") | gsub("(?<a>mauve:[^\"*]*)\"";"\(.a)*\"")
      else . end
    )
  | join("\n");

map(
  (if (.usercssData.vars? // null) != null then
     .usercssData.vars |= with_entries(
       if .key == "lightFlavor" or .key == "darkFlavor" then .value |= setvar("mocha")
       elif .key == "accentColor" then .value |= setvar("mauve")
       else . end)
   else . end)
  | (if (.sourceCode? // null) != null then .sourceCode |= markdefaults else . end)
  | (if (.usercssData.name? // "") == "Gmail Catppuccin"
     then .sourceCode += "\n\n" + $gmail else . end)
)
