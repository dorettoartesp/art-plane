/**
 * Copyright (c) 2023-present Plane Software, Inc. and contributors
 * SPDX-License-Identifier: AGPL-3.0-only
 * See the LICENSE file for details.
 */

export function AuthFooter() {
  return (
    <div className="flex flex-col items-center gap-6">
      <span className="text-13 whitespace-nowrap text-tertiary">
        Ambiente institucional ARTESP baseado no Plane CE
      </span>
      <div className="flex flex-wrap items-center justify-center gap-x-3 gap-y-2 text-center text-12 text-tertiary">
        <span>Licenciado sob AGPL v3.</span>
        <a
          href="https://github.com/dorettoartesp/art-plane"
          target="_blank"
          rel="noreferrer"
          className="text-accent-primary hover:underline"
        >
          Código-fonte correspondente
        </a>
      </div>
    </div>
  );
}
