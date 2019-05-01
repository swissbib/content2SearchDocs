package org.swissbib.flink;

import org.swissbib.SbMetadataModel;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Base64;

public class FlinkSbMetadaModel {

    /**
     * Prefix signalling a base64 encoded String
     */
    final static char base64Prefix = '\u180E';
    /**
     * Character used for separating different (meta-)data fields
     */
    final static String fieldSeparator = "\u200B";
    /**
     * Character used for separating key and value(s)
     */
    final static String keyValueSeparator = "\u200c";
    /**
     * Character used for separating list elements
     */
    final static String listElementSeparator = "\u200d";

    /**
     * The data
     */
    private String data;

    /**
     * Status of message
     */
    private String status;

    /**
     * Category of message
     */
    private String category;

    /**
     *  Version of message
     */
    private Long version = null;

    public String getData() {
        return isNull(data) ? null : (isBase64String(data) ? decodeString(data) : data);
    }

    public FlinkSbMetadaModel setData(String data) {
        this.data = shouldBeBase64Encoded(data) ? encodeStringToBase64(data) : data;
        return this;
    }

    public ArrayList<String> getStatus() {
        return isNull(status) ? null : toListElements(status);
    }

    public FlinkSbMetadaModel setStatus(String[] status) {
        this.status = addListElements(this.status, concatListElements(status));
        return this;
    }

    public FlinkSbMetadaModel setStatus(String status) {
        this.status = addListElements(this.status, shouldBeBase64Encoded(status) ? encodeStringToBase64(status) : status);
        return this;
    }

    public ArrayList<String> getCategory() {
        return isNull(category) ? null : toListElements(category);
    }

    public FlinkSbMetadaModel setCategory(String[] category) {
        this.category = addListElements(this.category, concatListElements(category));
        return this;
    }

    public FlinkSbMetadaModel setCategory(String category) {
        this.category = addListElements(this.category, shouldBeBase64Encoded(category) ? encodeStringToBase64(category) : category);
        return this;
    }

    /**
     *
     * @return Whether this message contains a version number.
     */
    public boolean hasVersion() {
        return version != null;
    }

    /**
     *
     * @return The version number of this message.
     * @throws NullPointerException - when no version is defined.
     */
    public long getVersion() throws NullPointerException {
        return version;
    }

    public FlinkSbMetadaModel setVersion(long version) {
        this.version = version;
        return this;
    }

    /**
     * Parse byte array as {@link SbMetadataModel}
     *
     * @param binaryData Byte array to be parsed
     * @param encoding   Characters encoding
     * @return Instance of type {@link SbMetadataModel}
     * @throws UnsupportedEncodingException If encoding is not supported
     * @see #toByteArray(String) for opposite operation
     */
    FlinkSbMetadaModel fromByteArray(byte[] binaryData, String encoding) throws UnsupportedEncodingException {
        String rawData = new String(binaryData, encoding);
        for (String fields : rawData.split(fieldSeparator)) {
            String[] keyValue = fields.split(keyValueSeparator, 2);
            switch (keyValue[0]) {
                case "data":
                    this.data = keyValue[1];
                    break;
                case "category":
                    this.category = keyValue[1];
                    break;
                case "status":
                    this.status = keyValue[1];
                    break;
                case "version":
                    this.version = Long.parseLong(keyValue[1]);
                    break;
            }
        }
        return this;
    }

    /**
     * Returns {@link SbMetadataModel} instance as byte array
     *
     * @param encoding Characters encoding
     * @return Instance as byte array
     * @throws UnsupportedEncodingException If encoding is not supported
     * @see #fromByteArray(byte[], String) for opposite operation
     */
    byte[] toByteArray(String encoding) throws UnsupportedEncodingException {
        String rawData = "";
        if (!isNull(data)) {
            rawData = concatFields(rawData, "data" + keyValueSeparator + data);
        }
        if (!isNull(category)) {
            rawData = concatFields(rawData, "category" + keyValueSeparator + category);
        }
        if (!isNull(status)) {
            rawData = concatFields(rawData, "status" + keyValueSeparator + status);
        }
        if (hasVersion()) {
            rawData = concatFields(rawData, "version" + keyValueSeparator + version.toString());
        }
        return rawData.getBytes(encoding);
    }

    /**
     * Add String to existing String of list elements using {@link this.listElementSeparator}}
     *
     * @param s1 First (base) String
     * @param s2 Second String
     * @return Concatenated String
     */
    private String addListElements(String s1, String s2) {
        return isNull(s1) ? s2 : s1 + listElementSeparator + s2;
    }

    /**
     * Concatenates two fields using {@link #fieldSeparator}
     *
     * @param s1 First (base) String
     * @param s2 Second String
     * @return Concatenated String
     */
    private String concatFields(String s1, String s2) {
        return isNull(s1) ? s2 : s1 + fieldSeparator + s2;
    }

    /**
     * Concatenates and possibly encodes individual list elements to String using {@link #listElementSeparator}
     *
     * @param listElements List elements to be concatenated
     * @return String of possibly encoded list elements
     * @see #toListElements(String) for the opposite operation
     */
    private String concatListElements(String[] listElements) {
        StringBuilder sB = new StringBuilder();
        boolean init = true;
        for (String s : listElements) {
            if (init) {
                init = false;
            } else {
                sB.append(listElementSeparator);
            }
            sB.append(shouldBeBase64Encoded(s) ? encodeStringToBase64(s) : s);
        }
        return sB.toString();
    }

    /**
     * Splits String to individual list elements using {@link #listElementSeparator}
     *
     * @param s String to be split
     * @return {@link ArrayList<String>} of individual elements
     * @see #concatListElements(String[]) for the opposite operation
     */
    private ArrayList<String> toListElements(String s) {
        String[] splitString = s.split(listElementSeparator);
        ArrayList<String> decodedValues = new ArrayList<>();
        for (String sS : splitString) {
            decodedValues.add(isBase64String(sS) ? decodeString(sS) : sS);
        }
        return decodedValues;
    }

    /**
     * Encode a String as binary data (Base64 encoding)
     *
     * @param s String
     * @return Encoded String
     * @see #decodeString(String) for the opposite operation
     */
    private String encodeStringToBase64(String s) {
        return base64Prefix + Base64.getEncoder().encodeToString(s.getBytes());
    }

    /**
     * Decode binary data (represented as String) as String (from Base64)
     *
     * @param s Encoded String
     * @return Decoded String
     * @see #encodeStringToBase64(String) for the opposite operation
     */
    private String decodeString(String s) {
        return new String(Base64.getDecoder().decode(s.substring(1)));
    }

    /**
     * Checks if String is Base64 encoded
     *
     * @param s String
     * @return true if Base64 encoded
     */
    private boolean isBase64String(String s) {
        return s.indexOf(base64Prefix) == 0;
    }

    /**
     * Checks if String contains special characters and therefore must be encoded
     *
     * @param s String under scrutiny
     * @return true if String should be encoded
     */
    private boolean shouldBeBase64Encoded(String s) {
        return (s.contains(fieldSeparator) ||
                s.contains(keyValueSeparator) ||
                s.contains(listElementSeparator)) ||
                s.indexOf(base64Prefix) == 0;
    }

    private boolean isNull(String s) {
        return s == null || s.length() == 0;
    }


}
