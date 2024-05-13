#!/bin/bash
# shellcheck disable=SC2034,SC2153,SC2155,SC2164

# Copyright Istio Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# @setup profile=none
set -e
set -u
set -o pipefail

source "content/en/docs/ambient/getting-started/snips.sh"
source "tests/util/samples.sh"

# install istio with ambient profile
snip_download_and_install_3
_wait_for_deployment istio-system istiod
_wait_for_daemonset istio-system ztunnel
_wait_for_daemonset istio-system istio-cni-node
_verify_like snip_download_and_install_5 "$snip_download_and_install_5_out"

# deploy sample applications
snip_deploy_the_sample_application_1
snip_deploy_the_sample_application_2
snip_deploy_the_sample_application_3
snip_deploy_the_sample_application_4

# test traffic before ambient mode is enabled
# _verify_contains snip_verify_traffic_sleep_to_ingress "$snip_verify_traffic_sleep_to_ingress_out"
# _verify_contains snip_verify_traffic_sleep_to_productpage "$snip_verify_traffic_sleep_to_productpage_out"
# _verify_contains snip_verify_traffic_notsleep_to_productpage "$snip_verify_traffic_notsleep_to_productpage_out"

# Label the default namespace to enable Istio's ambient mode for data plane configuration
# kubectl label namespace default istio.io/dataplane-mode=ambient

# kubectl label namespace default istio.io/dataplane-mode-
# @cleanup
istioctl uninstall -y --purge
snip_uninstall_3
cleanup_bookinfo_sample