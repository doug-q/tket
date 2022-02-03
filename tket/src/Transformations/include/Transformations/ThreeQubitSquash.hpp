// Copyright 2019-2022 Cambridge Quantum Computing
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#pragma once

#include "Transform.hpp"

namespace tket {

namespace Transforms {

/**
 * Squash sequences of 3-qubit instructions into their canonical 20-CX form.
 *
 * The circuit should comprise only CX and single-qubit gates. The transform
 * may perform a combination of 2-qubit (KAK) and 3-qubit decompositions of
 * subcircuits, but only does so if this reduces the CX count.
 *
 * @return Transform implementing the squash
 */
Transform three_qubit_squash();

}  // namespace Transforms

}  // namespace tket