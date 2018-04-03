/**
 * Copyright 2017 Plexus Interop Deutsche Bank AG
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.db.plexus.interop.dsl.gen.csharp

import com.db.plexus.interop.dsl.gen.PlexusGenConfig
import com.db.plexus.interop.dsl.protobuf.Message
import com.db.plexus.interop.dsl.protobuf.Method
import com.db.plexus.interop.dsl.protobuf.Option
import com.db.plexus.interop.dsl.protobuf.Proto
import com.db.plexus.interop.dsl.protobuf.Service
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.resource.XtextResource

import com.db.plexus.interop.dsl.Application
import com.db.plexus.interop.dsl.ProvidedService
import org.eclipse.emf.common.util.URI
import com.db.plexus.interop.dsl.ConsumedService
import org.eclipse.xtext.naming.QualifiedName
import com.db.plexus.interop.dsl.protobuf.StringConstant
import com.google.inject.Inject
import static extension com.db.plexus.interop.dsl.gen.GenUtils.*
import com.db.plexus.interop.dsl.gen.GenUtils

class CsharpCodeGenerator  {
	
	private static final QualifiedName CSHARP_NAMESPACE_OPTION_DESCRIPTOR_NAME = QualifiedName.create("", "google", "protobuf", "FileOptions", "csharp_namespace")
	
	@Inject
	GenUtils utils 
	    
    IQualifiedNameProvider qualifiedNameProvider    
    PlexusGenConfig config    
    URI baseDirUri
    String accessModifier
      
    new(PlexusGenConfig config, IQualifiedNameProvider qualifiedNameProvider, URI baseDirUri, String accessModifier) {
    	this.accessModifier = accessModifier;    	
    	this.config = config
    	this.qualifiedNameProvider = qualifiedNameProvider
    	this.baseDirUri = baseDirUri
    }
    
    def String gen(XtextResource resource) {
		'''		
			// <auto-generated>
			// 	Generated by the Plexus Interop compiler.  DO NOT EDIT!
			// 	source: «resource.URI.deresolve(baseDirUri).toFileString»
			// </auto-generated>
			#pragma warning disable 1591, 0612, 3021
			#region Designer generated code
			namespace «resource.csharpNamespace» {
				
				using System;
				using global::Plexus;
				using global::Plexus.Channels;
				using global::Plexus.Interop;
				using global::System.Threading.Tasks;
								
				«FOR service : resource.services SEPARATOR '\n'»
					«gen(service)»
				«ENDFOR»
								
				«FOR application : resource.applications SEPARATOR '\n'»
					«gen(application)»
				«ENDFOR»
			}
			#endregion Designer generated code
		'''
	}
	
	def String gen(Application application) {
		'''
			«accessModifier» partial interface I«application.clientName»: IClient {
				«FOR consumedService: application.consumedServices SEPARATOR '\n'»										
					«application.clientName».I«consumedService.aliasOrName»Proxy «consumedService.aliasOrName» { get; }
				«ENDFOR»				
			}

			«accessModifier» sealed partial class «application.clientName»: ClientBase, I«application.clientName» {
				
				public const string Id = "«utils.getFullName(application)»";
				
				«IF application.providedServices.length > 0»				
				private static ClientOptions CreateClientOptions(«application.clientName».ServiceBinder serviceBinder, Func<ClientOptionsBuilder, ClientOptionsBuilder> setup = null) {
					ClientOptionsBuilder builder = new ClientOptionsBuilder().WithApplicationId(Id).WithDefaultConfiguration();
					serviceBinder.Bind(builder);
					if (setup != null) {
						builder = setup(builder);
					}
					return builder.Build();
				}
				
				public «application.clientName»(
					«FOR providedService: application.providedServices»
						«application.clientName».I«providedService.aliasOrName»Impl «providedService.aliasOrName.toFirstLower»,
					«ENDFOR»
					Func<ClientOptionsBuilder, ClientOptionsBuilder> setup = null
				)
				:this(new «application.clientName».ServiceBinder(
					«FOR providedService: application.providedServices SEPARATOR ','»
						«providedService.aliasOrName.toFirstLower»
					«ENDFOR»					
				), setup) { }
				
				public «application.clientName»(«application.clientName».ServiceBinder serviceBinder, Func<ClientOptionsBuilder, ClientOptionsBuilder> setup = null): base(CreateClientOptions(serviceBinder, setup)) 
				{
					«FOR consumedService : application.consumedServices»
					«consumedService.aliasOrName» = new «application.clientName».«consumedService.aliasOrName»Proxy(this.CallInvoker);
					«ENDFOR»
				}

				public sealed partial class ServiceBinder {
					
					public ServiceBinder(
						«FOR providedService: application.providedServices SEPARATOR ','»
							«application.clientName».I«providedService.aliasOrName»Impl «providedService.aliasOrName.toFirstLower»
						«ENDFOR»
					) {
						«FOR providedService: application.providedServices»
							_«providedService.aliasOrName.toFirstLower»Binder = new «application.clientName».«providedService.aliasOrName»Binder(«providedService.aliasOrName.toFirstLower»);
						«ENDFOR»
					}
					
					«FOR providedService: application.providedServices»
						private «providedService.aliasOrName»Binder _«providedService.aliasOrName.toFirstLower»Binder;
					«ENDFOR»
					
					public ClientOptionsBuilder Bind(ClientOptionsBuilder builder) {
						«FOR providedService: application.providedServices»
							builder = _«providedService.aliasOrName.toFirstLower»Binder.Bind(builder);
						«ENDFOR»
						return builder;
					}
				}

				«FOR providedService: application.providedServices SEPARATOR '\n'»
					public partial interface I«providedService.aliasOrName»Impl«IF providedService.methods.length > 0»:«ENDIF»
						«FOR providedMethod : providedService.methods SEPARATOR ','»
							«providedService.service.csharpFullName».I«providedMethod.method.name.toFirstUpper»Impl
						«ENDFOR»
					{ }
					
					private sealed partial class «providedService.aliasOrName»Binder {
						
						«IF providedService.alias !== null»
						public const string Alias = "«providedService.alias»";
						«ENDIF»
						
						private readonly I«providedService.aliasOrName»Impl _impl;
						
						public «providedService.aliasOrName»Binder(I«providedService.aliasOrName»Impl impl) {
							_impl = impl;
						}
						
						public ClientOptionsBuilder Bind(ClientOptionsBuilder builder) {
							«IF providedService.alias === null»
							return builder.WithProvidedService(«providedService.service.getCsharpFullName()».Id, Bind);
							«ELSE»
							return builder.WithProvidedService(«providedService.service.getCsharpFullName()».Id, Alias, Bind);
							«ENDIF»							
						}
						
						private ProvidedServiceDefinition.Builder Bind(ProvidedServiceDefinition.Builder builder) {
							«FOR providedMethod : providedService.methods»
								«IF providedMethod.method.isPointToPoint»
								builder = builder.WithUnaryMethod«providedMethod.method.genericArgs»(«providedMethod.method.service.getCsharpFullName()».«providedMethod.method.name.toFirstUpper»MethodId, _impl.«providedMethod.method.name.toFirstUpper»);
								«ELSEIF providedMethod.method.serverStreaming»
								builder = builder.WithServerStreamingMethod«providedMethod.method.genericArgs»(«providedMethod.method.service.getCsharpFullName()».«providedMethod.method.name.toFirstUpper»MethodId, _impl.«providedMethod.method.name.toFirstUpper»);
								«ELSEIF providedMethod.method.clientStreaming»
								builder = builder.WithClientStreamingMethod«providedMethod.method.genericArgs»(«providedMethod.method.service.getCsharpFullName()».«providedMethod.method.name.toFirstUpper»MethodId, _impl.«providedMethod.method.name.toFirstUpper»);
								«ELSEIF providedMethod.method.bidiStreaming»
								builder = builder.WithDuplexStreamingMethod«providedMethod.method.genericArgs»(«providedMethod.method.service.getCsharpFullName()».«providedMethod.method.name.toFirstUpper»MethodId, _impl.«providedMethod.method.name.toFirstUpper»);
								«ENDIF»														
							«ENDFOR»
							return builder; 							
						}
					}
					
					public sealed partial class «providedService.aliasOrName»Impl: I«providedService.aliasOrName»Impl
					{
						«FOR providedMethod : providedService.methods»
							private readonly «providedMethod.method.genHandlerSignature» _«providedMethod.method.name.toFirstLower»Handler;
						«ENDFOR»
						
						public «providedService.aliasOrName»Impl(
							«FOR providedMethod : providedService.methods SEPARATOR ','»
								«providedMethod.method.genHandlerSignature» «providedMethod.method.name.toFirstLower»Handler
							«ENDFOR»
						) {
							«FOR providedMethod : providedService.methods»
								_«providedMethod.method.name.toFirstLower»Handler = «providedMethod.method.name.toFirstLower»Handler;
							«ENDFOR»
						}
						
						«FOR providedMethod : providedService.methods SEPARATOR '\n'»
							public «genImplSignature(providedMethod.method)» {
								return _«providedMethod.method.name.toFirstLower»Handler«genCallCode(providedMethod.method)»;
							}
						«ENDFOR»						
					}					
					
					public sealed partial class «providedService.aliasOrName»Impl<T>: I«providedService.aliasOrName»Impl
						«IF providedService.methods.length > 0»
							where T:
							«FOR providedMethod : providedService.methods SEPARATOR ','»
								«providedService.service.csharpFullName».I«providedMethod.method.name.toFirstUpper»Impl
							«ENDFOR»
						«ENDIF» 
					{
						private readonly T _impl;
						
						public «providedService.aliasOrName»Impl(T impl) {
							_impl = impl;
						}
						
						«FOR providedMethod : providedService.methods SEPARATOR '\n'»
							public «genImplSignature(providedMethod.method)» {
								return «genImplCallCode(providedMethod.method, "_impl")»;
							}
						«ENDFOR»						
					}
				«ENDFOR»
				«ELSE»
					private static ClientOptions CreateClientOptions(Func<ClientOptionsBuilder, ClientOptionsBuilder> setup = null) {
						ClientOptionsBuilder builder = new ClientOptionsBuilder().WithApplicationId(Id).WithDefaultConfiguration();
						if (setup != null) {
							builder = setup(builder);
						}									
						return builder.Build();					
					}
					
					public «application.clientName»(Func<ClientOptionsBuilder, ClientOptionsBuilder> setup = null): base(CreateClientOptions(setup)) 
					{ 
						«FOR consumedService : application.consumedServices»
						«consumedService.aliasOrName» = new «application.clientName».«consumedService.aliasOrName»Proxy(this.CallInvoker);
						«ENDFOR»						
					}
				«ENDIF»
				
				«FOR consumedService: application.consumedServices SEPARATOR '\n'»					
					public partial interface I«consumedService.aliasOrName»Proxy«IF consumedService.methods.length > 0»:«ENDIF»
						«FOR consumedMethod : consumedService.methods SEPARATOR ','»
							«consumedService.service.csharpFullName».I«consumedMethod.method.name.toFirstUpper»Proxy
						«ENDFOR»						
					{ }
					
					public sealed partial class «consumedService.aliasOrName»Proxy: I«consumedService.aliasOrName»Proxy {
						
						«IF consumedService.alias === null»
						public static «consumedService.service.csharpFullName».Descriptor Descriptor = «consumedService.service.csharpFullName».DefaultDescriptor;
						«ELSE»
						public const string Alias = "«consumedService.alias»";
						
						public static «consumedService.service.csharpFullName».Descriptor Descriptor = «consumedService.service.csharpFullName».CreateDescriptor(Alias);
						«ENDIF»
						
						private readonly IClientCallInvoker _callInvoker;
												
						public «consumedService.service.name.toFirstUpper»Proxy(IClientCallInvoker callInvoker) {
							_callInvoker = callInvoker;
						}						
						
						«FOR consumedMethod : consumedService.methods SEPARATOR '\n'»
							public «consumedMethod.method.genProxySignature("request")» {
								«IF consumedMethod.method.request.isStream»
									return _callInvoker.Call(Descriptor.«consumedMethod.method.name.toFirstUpper»Method);
								«ELSE»
									return _callInvoker.Call(Descriptor.«consumedMethod.method.name.toFirstUpper»Method, request);
								«ENDIF»								
							}
						«ENDFOR»
					}
					
					public I«consumedService.aliasOrName»Proxy «consumedService.aliasOrName» { get; private set; }
				«ENDFOR»
			}
		'''		
	}
	
	def String gen(Service service) {
		'''
			«accessModifier» static partial class «service.name.toFirstUpper» {
				
				public const string Id = "«utils.getFullName(service)»";			
				«FOR method : service.methods»
					public const string «method.name.toFirstUpper»MethodId = "«method.name»";
				«ENDFOR»
				
				public static readonly «service.name.toFirstUpper».Descriptor DefaultDescriptor = CreateDescriptor();
				
				public static «service.name.toFirstUpper».Descriptor CreateDescriptor() {
					return new «service.name.toFirstUpper».Descriptor();
				} 
				
				public static «service.name.toFirstUpper».Descriptor CreateDescriptor(string alias) {
					return new «service.name.toFirstUpper».Descriptor(alias);
				}				
			
				«FOR method : service.methods SEPARATOR '\n'»
				public partial interface I«method.name.toFirstUpper»Proxy {
					«genProxySignature(method, "request")»;
				}
				«ENDFOR»
				
				«FOR method : service.methods SEPARATOR '\n'»
				public partial interface I«method.name.toFirstUpper»Impl {
					«genImplSignature(method)»;
				}
				«ENDFOR»
				
				public sealed partial class Descriptor {
				
					«FOR method : service.methods»
					public «method.csharpTypeDeclaration» «method.name.toFirstUpper»Method {get; private set; }
					«ENDFOR»
					
					public Descriptor() {				
						«FOR method : service.methods»
							«method.name.toFirstUpper»Method = Method.«method.type»«method.genericArgs»(Id, «method.name.toFirstUpper»MethodId);
						«ENDFOR»
					}
				
					public Descriptor(string alias) {
						«FOR method : service.methods»
							«method.name.toFirstUpper»Method = Method.«method.type»«method.genericArgs»(Id, alias, «method.name.toFirstUpper»MethodId);
						«ENDFOR»
					}
				}
			}
		'''
	}

	def String genProxySignature(Method method, String requestVarName) {
		if (method.pointToPoint) {
			'''IUnaryMethodCall<«method.response.message.csharpFullName»> «method.name.toFirstUpper»(«method.request.message.csharpFullName» «requestVarName»)'''
		} else if (method.serverStreaming) {
			'''IServerStreamingMethodCall<«method.response.message.csharpFullName»> «method.name.toFirstUpper»(«method.request.message.csharpFullName» «requestVarName»)'''
		} else if (method.clientStreaming) {
			'''IClientStreamingMethodCall<«method.request.message.csharpFullName», «method.response.message.csharpFullName»> «method.name.toFirstUpper»()'''
		} else if (method.bidiStreaming) {
			'''IDuplexStreamingMethodCall<«method.request.message.csharpFullName», «method.response.message.csharpFullName»> «method.name.toFirstUpper»()'''
		}
	}

	def String genImplSignature(Method method) {
		if (method.pointToPoint) {
			'''Task<«method.response.message.csharpFullName»> «method.name.toFirstUpper»(«method.request.message.csharpFullName» request, MethodCallContext context)'''
		} else if (method.serverStreaming) {
			'''Task «method.name.toFirstUpper»(«method.request.message.csharpFullName» request, IWritableChannel<«method.response.message.csharpFullName»> responseStream, MethodCallContext context)'''
		} else if (method.clientStreaming) {
			'''Task<«method.response.message.csharpFullName»> «method.name.toFirstUpper»(IReadableChannel<«method.request.message.csharpFullName»> requestStream, MethodCallContext context)'''
		} else if (method.bidiStreaming) {
			'''Task «method.name.toFirstUpper»(IReadableChannel<«method.request.message.csharpFullName»> requestStream, IWritableChannel<«method.response.message.csharpFullName»> responseStream, MethodCallContext context)'''
		}
	}
	
	def String genHandlerSignature(Method method) {
		return '''«method.type»MethodHandler«method.genericArgs»'''
	}	
	

	def String genMethodDescriptorStaticDeclaration(Method method) {
		'''public static readonly «method.getCsharpTypeDeclaration» «method.name.toFirstUpper»Method = «genMethodDescriptorDeclaration(method)»;'''
	}

	def String genMethodDescriptorDeclaration(Method method) {
		val serviceName = utils.getFullName(method.service);
		val type = method.type
		'''Method.«type»«method.genericArgs»("«serviceName»", "«method.name»")'''
	}

	def String genMethodDescriptorDeclaration(Method method, String aliasVar) {
		val serviceName = utils.getFullName(method.service);
		val type = method.type
		'''Method.«type»«method.genericArgs»("«serviceName»", «aliasVar», "«method.name»")'''
	}

	def String getGenericArgs(Method method) {
		val requestName = method.request.message.csharpFullName
		val responseName = method.response.message.csharpFullName
		'''<«requestName», «responseName»>'''
	}

	def String getCsharpTypeDeclaration(Method method) {
		'''«method.type»Method«method.genericArgs»'''
	}

	def static String getType(Method method) {
		var methodType = "Unary"
		if (method.pointToPoint) {
			methodType = "Unary"
		} else if (method.serverStreaming) {
			methodType = "ServerStreaming"
		} else if (method.bidiStreaming) {
			methodType = "DuplexStreaming"
		} else if (method.clientStreaming) {
			methodType = "ClientStreaming"
		}
	}

	def getCsharpNamespace(Resource resource) {
		var ns = "Plexus.Interop.Generated";
		val package = resource.allContents.filter(typeof(Proto)).findFirst[x|true]
		if (package !== null) {					
			ns = qualifiedNameProvider.getFullyQualifiedName(package).skipFirst(1).segments.map[x|x.toFirstUpper].join(".");		
		}
		val option = package.eContents
			.filter(typeof(Option))
			.findFirst[o|qualifiedNameProvider.getFullyQualifiedName(o.descriptor).equals(CSHARP_NAMESPACE_OPTION_DESCRIPTOR_NAME)]
		if (option !== null) {
			ns = (option.value as StringConstant).value 						
		}
		if (config.namespace !== null) {
			ns = config.namespace;
		}
		return ns
	}

	def getCsharpFullName(Message obj) {
		return "global::" + getCsharpNamespace(obj.eResource) + "." + obj.name.toFirstUpper
	}    
	
	def getCsharpFullName(Service obj) {
		return "global::" + getCsharpNamespace(obj.eResource) + "." + obj.name.toFirstUpper
	}
	
	def String genCallCode(Method method) {
		if (method.pointToPoint) {
			'''(request, context)'''
		} else if (method.serverStreaming) {
			'''(request, responseStream, context)'''
		} else if (method.clientStreaming) {
			'''(requestStream, context)'''
		} else if (method.bidiStreaming) {			
			'''(requestStream, responseStream, context)'''
		}
	}	
	
	def String genImplCallCode(Method method, String varName) {
		if (method.pointToPoint) {
			'''«varName».«method.name.toFirstUpper»«method.genCallCode»'''
		} else if (method.serverStreaming) {
			'''«varName».«method.name.toFirstUpper»«method.genCallCode»'''
		} else if (method.clientStreaming) {
			'''«varName».«method.name.toFirstUpper»«method.genCallCode»'''
		} else if (method.bidiStreaming) {			
			'''«varName».«method.name.toFirstUpper»«method.genCallCode»'''
		}
	}	
	
	def String getAliasOrName(ProvidedService providedService) {
		if (providedService.alias !== null) providedService.alias.toFirstUpper else providedService.service.name.toFirstUpper 
	}
	
	def String getAliasOrName(ConsumedService consumedService) {
		if (consumedService.alias !== null) consumedService.alias.toFirstUpper else consumedService.service.name.toFirstUpper 
	}
	
	def getClientName(Application app) {
		if (app.name.endsWith("Client")) {
			return app.name.toFirstUpper
		} else {
			return '''«app.name.toFirstUpper»Client'''
		}		
	}	
}