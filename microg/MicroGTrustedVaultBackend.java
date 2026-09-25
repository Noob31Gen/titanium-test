// Copyright 2025 The Chromium Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package org.chromium.components.trusted_vault;

import android.app.PendingIntent;

import org.chromium.base.Promise;
import org.chromium.components.signin.base.CoreAccountInfo;

import java.util.Collections;
import java.util.List;

public class MicroGTrustedVaultBackend implements TrustedVaultClient.Backend {

    @Override
    public Promise<List<byte[]>> fetchKeys(CoreAccountInfo accountInfo) {
        return Promise.fulfilled(Collections.emptyList());
    }

    @Override
    public Promise<PendingIntent> createKeyRetrievalIntent(CoreAccountInfo accountInfo) {
        return Promise.rejected();
    }

    @Override
    public Promise<Boolean> markLocalKeysAsStale(CoreAccountInfo accountInfo) {
        return Promise.fulfilled(false);
    }

    @Override
    public Promise<Boolean> getIsRecoverabilityDegraded(CoreAccountInfo accountInfo) {
        return Promise.fulfilled(false);
    }

    @Override
    public Promise<Void> addTrustedRecoveryMethod(
            CoreAccountInfo accountInfo, byte[] publicKey, int methodTypeHint) {
        return Promise.rejected();
    }

    @Override
    public Promise<PendingIntent> createRecoverabilityDegradedIntent(CoreAccountInfo accountInfo) {
        return Promise.rejected();
    }

    @Override
    public Promise<PendingIntent> createOptInIntent(CoreAccountInfo accountInfo) {
        return Promise.rejected();
    }
}
