/**
 * Copyright 2018 Plexus Interop Deutsche Bank AG
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
﻿namespace Plexus.Interop.Protocol.Internal.Discovery
{
    using Plexus.Interop.Protocol.Discovery;
    using Plexus.Pools;
    using System.Collections.Generic;

    internal sealed class MethodDiscoveryResponse : PooledObject<MethodDiscoveryResponse>, IMethodDiscoveryResponse
    {
        protected override void Cleanup()
        {
            if (Methods == null)
            {
                return;
            }
            foreach (var method in Methods)
            {
                method.Dispose();
            }
            Methods = default;
        }

        public IReadOnlyCollection<IDiscoveredMethod> Methods { get; set; }

        public override string ToString()
        {
            return $"{nameof(Methods)}: {Methods}";
        }

        private bool Equals(MethodDiscoveryResponse other)
        {
            return Equals(Methods, other.Methods);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            return obj is MethodDiscoveryResponse && Equals((MethodDiscoveryResponse) obj);
        }

        public override int GetHashCode()
        {
            return (Methods != null ? Methods.GetHashCode() : 0);
        }
    }
}
