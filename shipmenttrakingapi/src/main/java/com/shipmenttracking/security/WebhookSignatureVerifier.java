package com.shipmenttracking.security;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.HexFormat;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public final class WebhookSignatureVerifier {

    private WebhookSignatureVerifier() {
    }

    public static boolean verify(
            byte[] rawBody,
            String secret,
            String suppliedSignature) {

        if (rawBody == null || secret == null || secret.isEmpty()
                || suppliedSignature == null
                || suppliedSignature.isBlank()) {
            return false;
        }

        try {
        	
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec key = new SecretKeySpec(
                    secret.getBytes(StandardCharsets.UTF_8),
                    "HmacSHA256");

            mac.init(key);
            byte[] expected = mac.doFinal(rawBody);

            String supplied = suppliedSignature.trim();

            // This version assumes the header contains a hexadecimal digest.
            if (supplied.startsWith("sha256=")) {
                supplied = supplied.substring("sha256=".length());
            }

            byte[] actual;
            try {
                actual = HexFormat.of().parseHex(supplied);
            } catch (IllegalArgumentException ex) {
                return false;
            }

            return MessageDigest.isEqual(expected, actual);

        } catch (Exception ex) {
            return false;
        }
    }
}
