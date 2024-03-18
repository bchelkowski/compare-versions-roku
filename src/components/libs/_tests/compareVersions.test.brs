' @import /components/KopytkoTestSuite.brs from @dazn/kopytko-unit-testing-framework

function TestSuite__compareVersions() as Object
  ts = KopytkoTestSuite()
  ts.name = "compareVersions"

  testEach([
    ["10", "9", ">", 1],
    ["10", "10", "=", 0],
    ["9", "10", "<", -1],
  ], "single-segment versions: {0} {2} {1}", function (_ts as Object, params as Object) as String
    ' When
    result = compareVersions(params[0], params[1])

    ' Then
    return expect(result).toBe(params[3])
  end function)

  testEach([
    ["10.8", "10.4", ">", 1],
    ["10.1", "10.1", "=", 0],
    ["10.1", "10.2", "<", -1],
  ], "two-segment versions: {0} {2} {1}", function (_ts as Object, params as Object) as String
    ' When
    result = compareVersions(params[0], params[1])

    ' Then
    return expect(result).toBe(params[3])
  end function)

  testEach([
    ["10.1.8", "10.0.4", ">", 1],
    ["10.0.1", "10.0.1", "=", 0],
    ["10.1.1", "10.2.2", "<", -1],
    ["11.0.10", "11.0.2", ">", 1],
    ["11.0.2", "11.0.10", "<", -1],
  ], "three-segment versions: ${0} ${2} ${1}", function (_ts as Object, params as Object) as String
    ' When
    result = compareVersions(params[0], params[1])

    ' Then
    return expect(result).toBe(params[3])
  end function)

  testEach([
    ["1.0.0.0", "1", "=", 0],
    ["1.0.0.0", "1.0", "=", 0],
    ["1.0.0.0", "1.0", "=", 0],
    ["1.0.0.0", "1.0.0", "=", 0],
    ["1.0.0.0", "1.0.0.0", "=", 0],
    ["1.2.3.4", "1.2.3.4", "=", 0],
    ["1.2.3.4", "1.2.3.04", "=", 0],
    ["v1.2.3.4", "01.2.3.4", "=", 0],
    ["1.2.3.4", "1.2.3.5", "<", -1],
    ["1.2.3.5", "1.2.3.4", ">", 1],
    ["1.0.0.0-alpha", "1.0.0-alpha", "=", 0],
    ["1.0.0.0-alpha", "1.0.0.0-beta", "<", -1],
  ], "four-segment versions: {0} {2} {1}", function (_ts as Object, params as Object) as String
    ' When
    result = compareVersions(params[0], params[1])

    ' Then
    return expect(result).toBe(params[3])
  end function)

  testEach([
    ["11.1.10", "11.0", ">", 1],
    ["1.1.1", "1", ">", 1],
    ["01.1.0", "1.01", "=", 0],
    ["1.0.0", "1", "=", 0],
    ["10.0.0", "10.114", "<", -1],
    ["1.0", "1.4.1", "<", -1],
  ], "different segment versions: {0} {2} {1}", function (_ts as Object, params as Object) as String
    ' When
    result = compareVersions(params[0], params[1])

    ' Then
    return expect(result).toBe(params[3])
  end function)

  testEach([
    ["1.0.0-alpha.1", "1.0.0-alpha", ">", 1],
    ["1.0.0-alpha", "1.0.0-alpha.1", "<", -1],
    ["1.0.0-alpha.1", "1.0.0-alpha.beta", "<", -1], ' failing
    ["1.0.0-alpha.beta", "1.0.0-beta", "<", -1], ' failing
    ["1.0.0-beta", "1.0.0-beta.2", "<", -1],
    ["1.0.0-beta.2", "1.0.0-beta.11", "<", -1],
    ["1.0.0-beta.11", "1.0.0-rc.1", "<", -1], ' failing
    ["1.0.0-rc.1", "1.0.0", "<", -1],
    ["1.0.0-alpha", "1", "<", -1],
    ["1.0.0-beta.11", "1.0.0-beta.1", ">", 1],
    ["1.0.0-beta.10", "1.0.0-beta.9", ">", 1],
    ["1.0.0-beta.10", "1.0.0-beta.90", "<", -1],
  ], "pre-release versions: {0} {2} {1}", function (_ts as Object, params as Object) as String
    ' When
    result = compareVersions(params[0], params[1])

    ' Then
    return expect(result).toBe(params[3])
  end function)

  testEach([
    ["1.4.0-build.3928", "1.4.0-build.3928+sha.a8d9d4f", "=", 0],
    ["1.4.0-build.3928+sha.b8dbdb0", "1.4.0-build.3928+sha.a8d9d4f", "=", 0],
    ["1.0.0-alpha+001", "1.0.0-alpha", "=", 0],
    ["1.0.0-beta+exp.sha.5114f85", "1.0.0-beta+exp.sha.999999", "=", 0],
    ["1.0.0+20130313144700", "1.0.0", "=", 0],
    ["1.0.0+20130313144700", "2.0.0", "<", -1],
    ["1.0.0+20130313144700", "1.0.1+11234343435", "<", -1],
    ["1.0.1+1", "1.0.1+2", "=", 0],
    ["1.0.0+a-a", "1.0.0+a-b", "=", 0],
  ], "ignore build metadata: {0} {2} {1}", function (_ts as Object, params as Object) as String
    ' When
    result = compareVersions(params[0], params[1])

    ' Then
    return expect(result).toBe(params[3])
  end function)

  testEach([
    ["v1.0.0", "1.0.0", "=", 0],
    ["v1.0.0", "v1.0.0", "=", 0],
    ["v1.0.0-alpha", "v1.0.0-alpha", "=", 0],
  ], "ignore leading `v`: {0} {2} {1}", function (_ts as Object, params as Object) as String
    ' When
    result = compareVersions(params[0], params[1])

    ' Then
    return expect(result).toBe(params[3])
  end function)

  testEach([
    ["01.0.0", "1", "=", 0],
    ["01.0.0", "1.0.0", "=", 0],
    ["1.01.0", "1.01.0", "=", 0],
    ["1.0.03", "1.0.3", "=", 0],
    ["1.0.03-alpha", "1.0.3-alpha", "=", 0],
    ["v01.0.0", "1.0.0", "=", 0],
    ["v01.0.0", "2.0.0", "<", -1],
  ], "ignore leading `0`: {0} {2} {1}", function (_ts as Object, params as Object) as String
    ' When
    result = compareVersions(params[0], params[1])

    ' Then
    return expect(result).toBe(params[3])
  end function)

  testEach([
    ["3", "3.x.x", "=", 0],
    ["3.3", "3.x.x", "=", 0],
    ["3.3.3", "3.x.x", "=", 0],
    ["3.x.x", "3.3.3", "=", 0],
    ["3.3.3", "3.X.X", "=", 0],
    ["3.3.3", "3.3.x", "=", 0],
    ["3.3.3", "3.*.*", "=", 0],
    ["3.3.3", "3.3.*", "=", 0],
    ["3.0.3", "3.0.*", "=", 0],
    ["0.7.x", "0.6.0", ">", 1],
    ["0.7.x", "0.6.0-asdf", ">", 1],
    ["0.7.x", "0.6.2", ">", 1],
    ["0.7.x", "0.7.0-asdf", ">", 1],
    ["1.2.*", "1.1.3", ">", 1],
    ["1.2.*", "1.1.9999", ">", 1],
    ["1.2.x", "1.0.0", ">", 1],
    ["1.2.x", "1.1.0", ">", 1],
    ["1.2.x", "1.1.3", ">", 1],
    ["2.*.*", "1.0.1", ">", 1],
    ["2.*.*", "1.1.3", ">", 1],
    ["2.x.x", "1.0.0", ">", 1],
    ["2.x.x", "1.1.3", ">", 1],
  ], "wildcards: {0} {2} {1}", function (_ts as Object, params as Object) as String
    ' When
    result = compareVersions(params[0], params[1])

    ' Then
    return expect(result).toBe(params[3])
  end function)

  testEach([
    ["3", "3.x.x", "=", 0],
    ["3.3", "3.x.x", "=", 0],
    ["3.3.3", "3.x.x", "=", 0],
    ["3.x.x", "3.3.3", "=", 0],
    ["3.3.3", "3.X.X", "=", 0],
    ["3.3.3", "3.3.x", "=", 0],
    ["3.3.3", "3.*.*", "=", 0],
    ["3.3.3", "3.3.*", "=", 0],
    ["3.0.3", "3.0.*", "=", 0],
    ["0.7.x", "0.6.0", ">", 1],
    ["0.7.x", "0.6.0-asdf", ">", 1],
    ["0.7.x", "0.6.2", ">", 1],
    ["0.7.x", "0.7.0-asdf", ">", 1],
    ["1.2.*", "1.1.3", ">", 1],
    ["1.2.*", "1.1.9999", ">", 1],
    ["1.2.x", "1.0.0", ">", 1],
    ["1.2.x", "1.1.0", ">", 1],
    ["1.2.x", "1.1.3", ">", 1],
    ["2.*.*", "1.0.1", ">", 1],
    ["2.*.*", "1.1.3", ">", 1],
    ["2.x.x", "1.0.0", ">", 1],
    ["2.x.x", "1.1.3", ">", 1],
  ], "wildcards: {0} {2} {1}", function (_ts as Object, params as Object) as String
    ' When
    result = compareVersions(params[0], params[1])

    ' Then
    return expect(result).toBe(params[3])
  end function)

  it("should throw an error for integer as version", function (_ts as Object) as String
    ' When
    try
      integerValue = 42
      compareVersions(integerValue, integerValue)
    catch error
      result = error.message
    end try
    
    ' Then
    return expect(result).toBe(["Type Mismatch. Unable to cast " , "Integer", " to ", "String", "."].join(Chr(34)))
  end function)

  it("should throw an error for associative array as version", function (_ts as Object) as String
    ' When
    try
      associativeArray = {}
      compareVersions(associativeArray, associativeArray)
    catch error
      result = error.message
    end try
    
    ' Then
    return expect(result).toBe(["Type Mismatch. Unable to cast " , "roAssociativeArray", " to ", "String", "."].join(Chr(34)))
  end function)

  it("should throw an error for array as version", function (_ts as Object) as String
    ' When
    try
      array = []
      compareVersions(array, array)
    catch error
      result = error.message
    end try
    
    ' Then
    return expect(result).toBe(["Type Mismatch. Unable to cast " , "roArray", " to ", "String", "."].join(Chr(34)))
  end function)

  it("should throw an error for function as version", function (_ts as Object) as String
    ' When
    try
      func = sub () : end sub
      compareVersions(func, func)
    catch error
      result = error.message
    end try
    
    ' Then
    return expect(result).toBe(["Type Mismatch. Unable to cast " , "Function", " to ", "String", "."].join(Chr(34)))
  end function)

  itEach([
    "6.3.",
    "1.2.3a",
    "1.2.-3a",
  ], "should throw an error for invalid version format", function (_ts as Object, invalidInput as Dynamic) as String
    ' When
    try
      compareVersions(invalidInput, invalidInput)
    catch error
      result = error.message
    end try
    
    ' Then
    return expect(result).toBe(["Invalid argument not valid semver (", invalidInput, " received)"].join(""))
  end function)

  return ts
end function
