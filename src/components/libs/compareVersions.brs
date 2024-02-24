' @import /components/getProperty.brs from @dazn/kopytko-utils
' @import /components/getType.brs from @dazn/kopytko-utils
' @import /components/ternary.brs from @dazn/kopytko-utils

' Compares two, semver version strings
' https://semver.org/
' @param {roString} v1 - first version string
' @param {roString} v2 - second version string
' @returns {Integer} - 1 when v1 is grater than v2, -1 when v2 is grater than v1, 0 when equal
function compareVersions(v1 as String, v2 as String) as Integer
  prototype = {}

  _severRegex = "^[v^~<>=]*?(\d+)(?:\.([x*]|\d+)(?:\.([x*]|\d+)(?:\.([x*]|\d+))?(?:-([\da-z\-]+(?:\.[\da-z\-]+)*))?(?:\+[\da-z\-]+(?:\.[\da-z\-]+)*)?)?)?$"
  prototype._severRegex = CreateObject("roRegex", _severRegex, "i")

  _compareVersions = function (context as Object, v1 as String, v2 as String) as Integer
    n1 = context._validateAndParse(v1)
    n2 = context._validateAndParse(v2)
  
    p1 = n1.pop()
    if (p1 = Invalid) then p1 = ""
    p2 = n2.pop()
    if (p2 = Invalid) then p2 = ""
  
    r = context._compareSegments(n1, n2)
  
    if (r <> 0) then return r
  
    if (p1 <> "" AND p2 <> "")
      return context._compareSegments(p1.split("."), p2.split("."))
    else if (p1 <> "" OR p2 <> "")
      return ternary(p1 <> "", -1, 1)
    end if
  
    return 0
  end function

  prototype._compareSegments = function (a as Object, b as Object) as Integer
    max = a.count()
    if (max < b.count()) then max = b.count()
    
    for i = 0 to max - 1
      aValue = a[i]
      if (aValue = Invalid) then aValue = "0"
      bValue = b[i]
      if (bValue = Invalid) then bValue = "0"

      r = m._compareStrings(aValue, bValue)
  
      if (r <> 0) then return r
    end for
  
    return 0
  end function

  prototype._compareStrings = function (a as String, b as String) as Integer
    if (m._isWildcard(a) OR m._isWildcard(b)) then return 0

    aParsed = m._tryParse(a)
    bParsed = m._tryParse(b)

    if (getType(aParsed) = "roString" OR getType(bParsed) = "roString")
      aParsed = aParsed.toStr()
      bParsed = bParsed.toStr()
    end if

    if (aParsed > bParsed) then return 1
    if (aParsed < bParsed) then return -1

    return 0
  end function

  prototype._isWildcard = function (sign as String) as Boolean
    return (sign = "*") OR (sign = "x") OR (sign = "X")
  end function

  prototype._tryParse = function (value as String) as Dynamic
    if (value = "") then return 0

    valueInt = Val(value, 10)

    if (valueInt = 0 AND value <> "0") then return value

    return valueInt
  end function

  prototype._validateAndParse = function (value as String) as Object
    match = m._severRegex.match(value)

    if (match.count() > 0)
      match.shift()
    end if

    jsMimicMatchOutput = []
    for i = 0 to 4
      jsMimicMatchOutput[i] = match[i]
    end for

    return jsMimicMatchOutput
  end function

  return _compareVersions(prototype, v1, v2)
end function
