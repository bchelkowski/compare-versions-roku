# compare-versions-roku

Compare [semver](https://semver.org/) version strings to find greater, equal or lesser.

Based on [https://github.com/omichelsen/compare-versions](https://github.com/omichelsen/compare-versions).

## Installation

### with kopytko-packager

When using [kopytko-packager](https://github.com/getndazn/kopytko-packager) you can simly define this package as a dependecy.

`npm i compare-versions-roku`

### without kopytko-packager

Copy `compareVersions.brs` file from this repository to your project.

**Remember that it uses also the `getProperty`, `getType`, and `ternary` functions from the `kopytko-utils`, [so copy it along with it](https://github.com/getndazn/kopytko-utils/blob/master/src/components.brs), or create a similar one.**

## Usage

```brightscript
' @import /components/libs/compareVersions.brs from compare-versions-roku

function areVersionsTheSame() as Boolean
  return compareVersions("1.2.0", "1.2")
end function
```

[For more examples, you can see test cases.](https://github.com/bchelkowski/compare-versions-roku/blob/main/src/components/libs/_tests/compareVersions.test.brs)

## Documentation

Currently, there is only compareVersions function.
It will return 1 if the first version is greater, 0 if the versions are equal, and -1 if the second version is greater:

`compareVersions(v1, v2)`

params:

- v1 (**roString**) - first version string
- v2 (**roString**) - second version string

returns (**roInteger**):

- `-1` - the second version is greater
- `0` - versions are equal
- `1` - first version is greater
