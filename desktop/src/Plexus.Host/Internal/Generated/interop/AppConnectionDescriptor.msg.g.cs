/**
 * Copyright 2017-2020 Plexus Interop Deutsche Bank AG
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
// <auto-generated>
//     Generated by the protocol buffer compiler.  DO NOT EDIT!
//     source: interop/app_connection_descriptor.proto
// </auto-generated>
#pragma warning disable 1591, 0612, 3021
#region Designer generated code

using pb = global::Google.Protobuf;
using pbc = global::Google.Protobuf.Collections;
using pbr = global::Google.Protobuf.Reflection;
using scg = global::System.Collections.Generic;
namespace Plexus.Host.Internal.Generated {

  /// <summary>Holder for reflection information generated from interop/app_connection_descriptor.proto</summary>
  internal static partial class AppConnectionDescriptorReflection {

    #region Descriptor
    /// <summary>File descriptor for interop/app_connection_descriptor.proto</summary>
    public static pbr::FileDescriptor Descriptor {
      get { return descriptor; }
    }
    private static pbr::FileDescriptor descriptor;

    static AppConnectionDescriptorReflection() {
      byte[] descriptorData = global::System.Convert.FromBase64String(
          string.Concat(
            "CidpbnRlcm9wL2FwcF9jb25uZWN0aW9uX2Rlc2NyaXB0b3IucHJvdG8SB2lu",
            "dGVyb3AaF2ludGVyb3AvdW5pcXVlX2lkLnByb3RvGhVpbnRlcm9wL29wdGlv",
            "bnMucHJvdG8ipAEKF0FwcENvbm5lY3Rpb25EZXNjcmlwdG9yEigKDWNvbm5l",
            "Y3Rpb25faWQYASABKAsyES5pbnRlcm9wLlVuaXF1ZUlkEg4KBmFwcF9pZBgC",
            "IAEoCRIqCg9hcHBfaW5zdGFuY2VfaWQYAyABKAsyES5pbnRlcm9wLlVuaXF1",
            "ZUlkOiOS2wQfaW50ZXJvcC5BcHBDb25uZWN0aW9uRGVzY3JpcHRvckIhqgIe",
            "UGxleHVzLkhvc3QuSW50ZXJuYWwuR2VuZXJhdGVkYgZwcm90bzM="));
      descriptor = pbr::FileDescriptor.FromGeneratedCode(descriptorData,
          new pbr::FileDescriptor[] { global::Plexus.Host.Internal.Generated.UniqueIdReflection.Descriptor, global::Plexus.Host.Internal.Generated.OptionsReflection.Descriptor, },
          new pbr::GeneratedClrTypeInfo(null, new pbr::GeneratedClrTypeInfo[] {
            new pbr::GeneratedClrTypeInfo(typeof(global::Plexus.Host.Internal.Generated.AppConnectionDescriptor), global::Plexus.Host.Internal.Generated.AppConnectionDescriptor.Parser, new[]{ "ConnectionId", "AppId", "AppInstanceId" }, null, null, null)
          }));
    }
    #endregion

  }
  #region Messages
  internal sealed partial class AppConnectionDescriptor : pb::IMessage<AppConnectionDescriptor> {
    private static readonly pb::MessageParser<AppConnectionDescriptor> _parser = new pb::MessageParser<AppConnectionDescriptor>(() => new AppConnectionDescriptor());
    private pb::UnknownFieldSet _unknownFields;
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pb::MessageParser<AppConnectionDescriptor> Parser { get { return _parser; } }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public static pbr::MessageDescriptor Descriptor {
      get { return global::Plexus.Host.Internal.Generated.AppConnectionDescriptorReflection.Descriptor.MessageTypes[0]; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    pbr::MessageDescriptor pb::IMessage.Descriptor {
      get { return Descriptor; }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public AppConnectionDescriptor() {
      OnConstruction();
    }

    partial void OnConstruction();

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public AppConnectionDescriptor(AppConnectionDescriptor other) : this() {
      ConnectionId = other.connectionId_ != null ? other.ConnectionId.Clone() : null;
      appId_ = other.appId_;
      AppInstanceId = other.appInstanceId_ != null ? other.AppInstanceId.Clone() : null;
      _unknownFields = pb::UnknownFieldSet.Clone(other._unknownFields);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public AppConnectionDescriptor Clone() {
      return new AppConnectionDescriptor(this);
    }

    /// <summary>Field number for the "connection_id" field.</summary>
    public const int ConnectionIdFieldNumber = 1;
    private global::Plexus.Host.Internal.Generated.UniqueId connectionId_;
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public global::Plexus.Host.Internal.Generated.UniqueId ConnectionId {
      get { return connectionId_; }
      set {
        connectionId_ = value;
      }
    }

    /// <summary>Field number for the "app_id" field.</summary>
    public const int AppIdFieldNumber = 2;
    private string appId_ = "";
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public string AppId {
      get { return appId_; }
      set {
        appId_ = pb::ProtoPreconditions.CheckNotNull(value, "value");
      }
    }

    /// <summary>Field number for the "app_instance_id" field.</summary>
    public const int AppInstanceIdFieldNumber = 3;
    private global::Plexus.Host.Internal.Generated.UniqueId appInstanceId_;
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public global::Plexus.Host.Internal.Generated.UniqueId AppInstanceId {
      get { return appInstanceId_; }
      set {
        appInstanceId_ = value;
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override bool Equals(object other) {
      return Equals(other as AppConnectionDescriptor);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public bool Equals(AppConnectionDescriptor other) {
      if (ReferenceEquals(other, null)) {
        return false;
      }
      if (ReferenceEquals(other, this)) {
        return true;
      }
      if (!object.Equals(ConnectionId, other.ConnectionId)) return false;
      if (AppId != other.AppId) return false;
      if (!object.Equals(AppInstanceId, other.AppInstanceId)) return false;
      return Equals(_unknownFields, other._unknownFields);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override int GetHashCode() {
      int hash = 1;
      if (connectionId_ != null) hash ^= ConnectionId.GetHashCode();
      if (AppId.Length != 0) hash ^= AppId.GetHashCode();
      if (appInstanceId_ != null) hash ^= AppInstanceId.GetHashCode();
      if (_unknownFields != null) {
        hash ^= _unknownFields.GetHashCode();
      }
      return hash;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public override string ToString() {
      return pb::JsonFormatter.ToDiagnosticString(this);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void WriteTo(pb::CodedOutputStream output) {
      if (connectionId_ != null) {
        output.WriteRawTag(10);
        output.WriteMessage(ConnectionId);
      }
      if (AppId.Length != 0) {
        output.WriteRawTag(18);
        output.WriteString(AppId);
      }
      if (appInstanceId_ != null) {
        output.WriteRawTag(26);
        output.WriteMessage(AppInstanceId);
      }
      if (_unknownFields != null) {
        _unknownFields.WriteTo(output);
      }
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public int CalculateSize() {
      int size = 0;
      if (connectionId_ != null) {
        size += 1 + pb::CodedOutputStream.ComputeMessageSize(ConnectionId);
      }
      if (AppId.Length != 0) {
        size += 1 + pb::CodedOutputStream.ComputeStringSize(AppId);
      }
      if (appInstanceId_ != null) {
        size += 1 + pb::CodedOutputStream.ComputeMessageSize(AppInstanceId);
      }
      if (_unknownFields != null) {
        size += _unknownFields.CalculateSize();
      }
      return size;
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(AppConnectionDescriptor other) {
      if (other == null) {
        return;
      }
      if (other.connectionId_ != null) {
        if (connectionId_ == null) {
          connectionId_ = new global::Plexus.Host.Internal.Generated.UniqueId();
        }
        ConnectionId.MergeFrom(other.ConnectionId);
      }
      if (other.AppId.Length != 0) {
        AppId = other.AppId;
      }
      if (other.appInstanceId_ != null) {
        if (appInstanceId_ == null) {
          appInstanceId_ = new global::Plexus.Host.Internal.Generated.UniqueId();
        }
        AppInstanceId.MergeFrom(other.AppInstanceId);
      }
      _unknownFields = pb::UnknownFieldSet.MergeFrom(_unknownFields, other._unknownFields);
    }

    [global::System.Diagnostics.DebuggerNonUserCodeAttribute]
    public void MergeFrom(pb::CodedInputStream input) {
      uint tag;
      while ((tag = input.ReadTag()) != 0) {
        switch(tag) {
          default:
            _unknownFields = pb::UnknownFieldSet.MergeFieldFrom(_unknownFields, input);
            break;
          case 10: {
            if (connectionId_ == null) {
              connectionId_ = new global::Plexus.Host.Internal.Generated.UniqueId();
            }
            input.ReadMessage(connectionId_);
            break;
          }
          case 18: {
            AppId = input.ReadString();
            break;
          }
          case 26: {
            if (appInstanceId_ == null) {
              appInstanceId_ = new global::Plexus.Host.Internal.Generated.UniqueId();
            }
            input.ReadMessage(appInstanceId_);
            break;
          }
        }
      }
    }

  }

  #endregion

}

#endregion Designer generated code
