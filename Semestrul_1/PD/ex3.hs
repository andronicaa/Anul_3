retChr :: String -> String
retChr '(' = " ("
retChr c = if c `elem` ",.:!?;)" then [c,' '] else [c]
f l = concat $map (retChr) $filter ((/=) ' ') l
