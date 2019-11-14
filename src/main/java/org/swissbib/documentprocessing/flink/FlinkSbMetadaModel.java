package org.swissbib.documentprocessing.flink;

import org.swissbib.types.CbsActions;
import org.swissbib.types.EsBulkActions;
import org.swissbib.types.EsMergeActions;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Base64;

public class FlinkSbMetadaModel  {

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
     * CBS action type
     */
    private CbsActions cbsAction;

    /**
     * The data
     */
    private String data;

    /**
     * Elasticsearch bulk action type
     */
    private EsBulkActions esBulkAction;

    /**
     * Name of Elasticsearch document type
     */
    private String esDocTypeName;

    /**
     * Version of message needs to match the corresponding version number of the index document.
     * If the indexed document has a higher version number the index operation is rejected and the
     * request will have to be retried.
     */
    private Long esDocumentVersion = null;

    /**
     * Used as an indication how the message should be prepared for indexing into elasticsearch.
     * This is used for a preprocessor before it is sent to the elastic consumer!
     * - NEW -> A new document will be created with this message or an existing document should be updated.
     * - UPDATE -> Only update an existing document, do not create a new document if no match was found.
     * - RETRY -> This document was rejected by elasticsearch due to a version conflict. Check whether it still needs to
     * be updated or not.
     */
    private EsMergeActions esMergeAction;

    /**
     * Name of Elasticsearch index
     */
    private String esIndexName;

    public FlinkSbMetadaModel setCbsAction(CbsActions cbsAction) {
        this.cbsAction = cbsAction;
        return this;
    }

    public CbsActions getCbsAction() {
        return cbsAction;
    }

    public String getData() {
        return isNull(data) ? null : (isBase64String(data) ? decodeString(data) : data);
    }

    public FlinkSbMetadaModel setData(String data) {
        this.data = shouldBeBase64Encoded(data) ? encodeStringToBase64(data) : data;
        return this;
    }

    public FlinkSbMetadaModel setEsBulkAction(EsBulkActions esBulkAction) {
        this.esBulkAction = esBulkAction;
        return this;
    }

    public EsBulkActions getEsBulkAction() {
        return esBulkAction;
    }

    public String getEsDocTypeName() {
        return esDocTypeName;
    }

    public FlinkSbMetadaModel setEsDocTypeName(String esDocTypeName) {
        this.esDocTypeName = esDocTypeName;
        return this;
    }

    /**
     * @return The esDocumentVersion number of this message.
     * @throws NullPointerException - when no esDocumentVersion is defined.
     */
    public long getEsDocumentVersion() throws NullPointerException {
        return esDocumentVersion;
    }

    public FlinkSbMetadaModel setEsDocumentVersion(long esDocumentVersion) {
        this.esDocumentVersion = esDocumentVersion;
        return this;
    }

    public EsMergeActions getEsMergeAction() {
        return esMergeAction;
    }

    public FlinkSbMetadaModel setEsMergeAction(EsMergeActions esMergeAction) {
        this.esMergeAction = esMergeAction;
        return this;
    }

    /**
     * @return Whether this message contains a esDocumentVersion number.
     */
    public boolean hasEsDocumentVersion() {
        return esDocumentVersion != null;
    }

    public String getEsIndexName() {
        return esIndexName;
    }

    public FlinkSbMetadaModel setEsIndexName(String esIndexName) {
        this.esIndexName = esIndexName;
        return this;
    }


    /**
     * Parse byte array as {@link FlinkSbMetadaModel}
     *
     * @param binaryData Byte array to be parsed
     * @param encoding   Characters encoding
     * @return Instance of type {@link FlinkSbMetadaModel}
     * @throws UnsupportedEncodingException If encoding is not supported
     * @see #toByteArray(String) for opposite operation
     */
    FlinkSbMetadaModel fromByteArray(byte[] binaryData, String encoding) throws UnsupportedEncodingException {
        String rawData = new String(binaryData, encoding);
        for (String fields : rawData.split(fieldSeparator)) {
            String[] keyValue = fields.split(keyValueSeparator, 2);
            switch (keyValue[0]) {
                case "cbsAction":
                    this.cbsAction = CbsActions.valueOf(keyValue[1]);
                    break;
                case "data":
                    this.data = keyValue[1];
                    break;
                case "esBulkAction":
                    this.esBulkAction = EsBulkActions.valueOf(keyValue[1]);
                    break;
                case "esDocTypeName":
                    this.esDocTypeName = keyValue[1];
                    break;
                case "esDocumentVersion":
                    this.esDocumentVersion = Long.parseLong(keyValue[1]);
                    break;
                case "esIndexName":
                    this.esIndexName = keyValue[1];
                    break;
                case "esMergeAction":
                    this.esMergeAction = EsMergeActions.valueOf(keyValue[1]);
            }
        }
        return this;
    }

    /**
     * Returns {@link FlinkSbMetadaModel} instance as byte array
     *
     * @param encoding Characters encoding
     * @return Instance as byte array
     * @throws UnsupportedEncodingException If encoding is not supported
     * @see #fromByteArray(byte[], String) for opposite operation
     */
    byte[] toByteArray(String encoding) throws UnsupportedEncodingException {
        String rawData = "";
        if (cbsAction != null) {
            rawData = concatFields(rawData, "cbsAction" + keyValueSeparator + cbsAction);
        }
        if (!isNull(data)) {
            rawData = concatFields(rawData, "data" + keyValueSeparator + data);
        }
        if (esBulkAction != null) {
            rawData = concatFields(rawData, "esBulkAction" + keyValueSeparator + esBulkAction);
        }
        if (!isNull(esDocTypeName)) {
            rawData = concatFields(rawData, "esDocTypeName" + keyValueSeparator + esDocTypeName);
        }
        if (hasEsDocumentVersion()) {
            rawData = concatFields(rawData, "esDocumentVersion" + keyValueSeparator + esDocumentVersion.toString());
        }
        if (!isNull(esIndexName)) {
            rawData = concatFields(rawData, "esIndexName" + keyValueSeparator + esIndexName);
        }
        if (esMergeAction != null) {
            rawData = concatFields(rawData, "esMergeAction" + keyValueSeparator + esMergeAction);
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
