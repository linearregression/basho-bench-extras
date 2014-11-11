%% -------------------------------------------------------------------
%%
%% basho-bench-riak-sets: Riak Set benchmark plugin for basho_bench
%%
%% Copyright (c) 2014 Gergely Nagy <algernon@madhouse-project.org>
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module(lmi_gen).

-export([new/2]).

-include("deps/basho_bench/include/basho_bench.hrl").

new({timeseries, BucketGenSpec, ChunkSize}, Id) ->
    BucketGen = basho_bench_keygen:new(BucketGenSpec, Id),
    Bucket = BucketGen(),
    Duration = basho_bench_config:get(duration),
    Clients = basho_bench_config:get(concurrent),
    MaxKeys = round(Duration * 60 / Clients * ChunkSize),
    KeyGen = basho_bench_keygen:new({int_to_bin_bigendian,
                                     {uniform_int, MaxKeys}}, Id),
    fun () ->
            {Bucket, KeyGen()}
    end.