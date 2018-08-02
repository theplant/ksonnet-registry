// @apiVersion 0.0.1
// @name jp.theplant.pkg.audit
// @description Log all requests at the Metadata level.
// @shortDescription Log all requests at the Metadata level.


local k = import "k.libsonnet";
local audit = import 'theplant/audit/audit.libsonnet';

k.core.v1.list.new([
  audit.parts.minimal()
])
