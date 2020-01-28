﻿/**
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
namespace Plexus.Interop.Apps.Internal
{
    using System;
    using System.Linq;
    using System.Reactive.Linq;
    using System.Reactive.Subjects;
    using System.Threading.Tasks;
    using Google.Protobuf.WellKnownTypes;
    using Plexus.Interop.Apps.Internal.Generated;
    using Plexus.Interop.Metamodel;
    using AppConnectionDescriptor = Plexus.Interop.Apps.AppConnectionDescriptor;
    using UniqueId = Plexus.UniqueId;

    internal class AppLaunchedEventProvider : IAppLaunchedEventProvider
    {
        private ILogger Log { get; } = LogManager.GetLogger<AppLaunchedEventProvider>();

        private readonly IRegistryProvider _registryProvider;
        private readonly Lazy<IClient> _client;

        private readonly ReplaySubject<AppLaunchedEvent> _appLaunchedSubject = new ReplaySubject<AppLaunchedEvent>(10);

        public AppLaunchedEventProvider(IAppConnectedEventProvider appConnectedEventProvider, IRegistryProvider registryProvider, Lazy<IClient> client)
        {
            _registryProvider = registryProvider;
            _client = client;
            appConnectedEventProvider.ConnectionEventsStream
                .Where(ev => ev.Type == ConnectionEventType.AppConnected)
                .Select(ev => ev.Connection)
                .Subscribe(OnAppConnected);

            AppLaunchedStream = _appLaunchedSubject;
        }

        private void OnAppConnected(AppConnectionDescriptor appConnectionDescriptor)
        {
            if (IsLauncher(appConnectionDescriptor, out var applicationId))
            {
                SubscribeToApplicationLaunchedEventStream(applicationId, appConnectionDescriptor.ConnectionId);
            }
        }

        private bool IsLauncher(AppConnectionDescriptor appConnectionDescriptor, out string applicationId)
        {
            applicationId = appConnectionDescriptor.ApplicationId;
            var isLauncherApplication = _registryProvider.Current.Applications[applicationId].ProvidedServices
                .Any(service => service.Service.Id == AppLauncherService.Id);
            return isLauncherApplication;
        }

        private void SubscribeToApplicationLaunchedEventStream(string applicationId, UniqueId connectionId)
        {
            var appLauncherServiceId = AppLauncherService.Id;
            var appLaunchedEventStreamMethodId = AppLauncherService.AppLaunchedEventStreamMethodId;
            var methodCallDescriptor = ProvidedMethodReference.Create(appLauncherServiceId, appLaunchedEventStreamMethodId, applicationId, connectionId);

            Task.Factory.StartNew(async () =>
            {
                Log.Info($"Subscribing to ApplicationLaunchedEventStream of {connectionId} application ({applicationId})");
                await _client.Value.CallInvoker
                    .CallServerStreaming<Empty, AppLaunchedEvent>(methodCallDescriptor.CallDescriptor, new Empty())
                    .ResponseStream.PipeAsync(_appLaunchedSubject).ConfigureAwait(false);
                Log.Info($"Subscription to ApplicationLaunchedEventStream of {connectionId} application ({applicationId}) have finished");
            }, TaskCreationOptions.LongRunning);
        }

        public IObservable<AppLaunchedEvent> AppLaunchedStream { get; }
    }
}
