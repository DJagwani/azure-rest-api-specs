import "@typespec/rest";
import "@typespec/openapi";
import "@typespec/versioning";
import "@azure-tools/typespec-providerhub";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "./helpers.tsp";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using Azure.Core;
using Azure.Core.Traits;
using TypeSpec.OpenAPI;

namespace Microsoft.Resources.Deployments;

@doc("The body of the request for the decompileBicep operation.")
model DecompileOperationRequest {
  @doc("The ARM json template to be decompiled into a Bicep file.")
  template: string;
}

@doc("The definition of a file along with its contents.")
model FileDefinition {
  @visibility("read")
  @doc("The path to the fille.")
  path: string;

  @visibility("read")
  @doc("The file contents.")
  contents: string;
}

@doc("The successful decompilation response.")
model DecompileOperationSuccessResponse {
  @visibility("read")
  @doc("An array of files decompiled from the ARM json template.")
  @extension("x-ms-identifiers", ["path"])
  files: FileDefinition[];

  @visibility("read")
  @doc("The file path to the main Bicep file generated from the decompiled ARM json template.")
  entryPoint: string;
}

@armResourceOperations
interface Bicep {
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-operation" "this is not a nested resource operation"
  @route("subscriptions/{subscriptionId}/providers/Microsoft.Resources/decompileBicep")
  @doc("Decompiles an ARM json template into a Bicep template.")
  decompileBicep is ArmActionSync<
    DecompileOperationRequest,
    DecompileOperationSuccessResponse
  >;
}