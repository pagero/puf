<?xml version="1.0" encoding="UTF-8"?>
<schema queryBinding="xslt2" schemaVersion="iso" xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils">

    <title>Rules for PUF 1.0 (Pagero Universal Format)</title>

    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:pagero:CommonAggregateComponents:1.0"/>
    <ns prefix="puf" uri="urn:pagero:ExtensionComponent:1.0"/>
    <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="ubl-creditnote" uri="urn:pagero:PageroUniversalFormat:CreditNote:1.0"/>
    <ns prefix="ubl-invoice" uri="urn:pagero:PageroUniversalFormat:Invoice:1.0"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
    <ns prefix="u" uri="utils"/>

    <!--
        Transaction rules
        Syntax: PUF-{NONE|REGION|VERTICAL}-RULENUMBER
        R0XX - Document level
        R1XX - Line level 
    -->

    <pattern>
        <!-- Document level -->
        <rule context="ubl-creditnote:CreditNote | ubl-invoice:Invoice">
            <assert flag="fatal" id="PUF-R001" test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:pagero.com:puf:billing:1.0')">[PUF-R001]-Customization identifier MUST have the value 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:pagero.com:puf:billing:1.0'.</assert>
            <assert flag="fatal" id="PUF-R002" test="starts-with(normalize-space(cbc:ProfileID/text()), 'urn:pagero.com:puf:billing:1.0')">[PUF-R002]-Profile identifier MUST have the value 'urn:pagero.com:puf:billing:1.0'.</assert>
        </rule>

        <rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:RegistrationData">
            <assert flag="fatal" id="PUF-R003" test="puf:IDType/@listID = 'PUF-001-REGISTRATIONDATA'">[PUF-R003]-Attribute listID MUST be 'PUF-001-REGISTRATIONDATA'</assert>
        </rule>

        <rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:ADAID">
            <assert flag="fatal" id="PUF-R004" test="puf:IDType/@listID = 'PUF-002-ADAID'">[PUF-R004]-Attribute listID MUST be 'PUF-002-ADAID'</assert>
        </rule>

        <rule context="cac:TaxExchangeRate">
            <assert flag="fatal" id="PUF-R005" test="not(normalize-space(cbc:SourceCurrencyCode/text()) = normalize-space(cbc:TargetCurrencyCode/text()))">[PUF-R005]-Source currency code MUST be different from target currency code when tax exchange rate calculation is provided.</assert>
            <assert flag="fatal" id="PUF-R006" test="string(cbc:MathematicOperatorCode) = 'Multiply'">[PUF-R006]-If tax exchange calculation is provided the mathematic operator code MUST equal "Multiply".</assert>
            <assert flag="fatal" id="PUF-R007" test="cbc:CalculationRate">[PUF-R007]-If tax exchange calculation is provided the calculation rate MUST exist.</assert>
            <assert flag="fatal" id="PUF-R008" test="cbc:SourceCurrencyCode and cbc:TargetCurrencyCode">[PUF-R008]-If tax exchange calculation is provided both source and target currency MUST be provided.</assert>
        </rule>

        <rule context="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxChargeability">
            <assert flag="fatal" id="PUF-R009" test="cbc:TaxTypeCode = 'I' or cbc:TaxTypeCode = 'S' or cbc:TaxTypeCode = 'D'">[PUF-R009]-Value in tax chargeability MUST be one of the valid codes "S","D" or "I".</assert>
        </rule>

        <rule context="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxCurrencyTaxableAmount">
            <assert flag="fatal" id="PUF-R010" test="@currencyID = //cbc:TaxCurrencyCode">[PUF-R010]-Tax currency taxable amounts currency MUST not differ from documents tax currency.</assert>
        </rule>

        <rule context="cac:TaxTotal/cac:TaxSubtotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:TaxSubtotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:TaxSubtotalExtension/puf:TaxCurrencyTaxAmount">
            <assert flag="fatal" id="PUF-R011" test="@currencyID = //cbc:TaxCurrencyCode">[PUF-R011]-Tax currency tax amounts currency MUST not differ from documents tax currency.</assert>
        </rule>

        <rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyTaxExclusiveAmount">
            <assert flag="fatal" id="PUF-R012" test="@currencyID = //cbc:TaxCurrencyCode">[PUF-R012]-Tax currency tax exclusive amounts currency MUST not differ from documents tax currency.</assert>
        </rule>

        <rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyTaxInclusiveAmount">
            <assert flag="fatal" id="PUF-R013" test="@currencyID = //cbc:TaxCurrencyCode">[PUF-R013]-Tax currency tax inclusive amounts currency MUST not differ from documents tax currency.</assert>
        </rule>

        <rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:TaxCurrencyPayableAmount">
            <assert flag="fatal" id="PUF-R014" test="@currencyID = //cbc:TaxCurrencyCode">[PUF-R014]-Tax currency payable amounts currency MUST not differ from documents tax currency.</assert>
        </rule>

        <rule context="cac:LegalMonetaryTotal/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:PaymentInKind/puf:Amount">
            <assert flag="fatal" id="PUF-R015" test="@currencyID = //cbc:DocumentCurrencyCode">[PUF-R015]-Payment in kind amount currency MUST not differ from document currency.</assert>
        </rule>

        <rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:RegistrationData/puf:IDType">
            <assert flag="fatal" id="PUF-R016" test="
                    (some $code in tokenize('IT:Ufficio IT:NumeroREA IT:CapitaleSociale IT:SocioUnico IT:StatoLiquidazione ES:Book ES:RegisterOfCompaniesLocation ES:Sheet ES:Folio ES:Section ES:Volume ES:AdditionalRegistrationData FR:DenomSociete FR:TypeSociete FR:CapitalSocial FR:RCSNumber FR:APE', '\s')
                        satisfies normalize-space(text()) = $code)">[PUF-R016]-ID type MUST be a valid type according to list PUF-001-REGISTRATIONDATA.</assert>
        </rule>

        <rule context="cac:Party/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PartyExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PartyExtension/puf:ADAID/puf:IDType">
            <assert flag="fatal" id="PUF-R017" test="
                (some $code in tokenize('FR:ServiceCode ES:OficinaContable ES:OrganoGestor ES:UnidadTramitadora ES:OrganoProponente GEN:UnitCode', '\s')
                        satisfies normalize-space(text()) = $code)">[PUF-R017]-ID type MUST be a valid type according to list PUF-002-ADAID.</assert>
        </rule>

        <!--Existing EN16931 rule BR-CO-16 refactored to not include withholding amount if withholding exist this is checked in Rule PUF-R003-BR-CO-16. If new values that affect payable amount these will need to be exlucded aswell-->
        <rule context="cac:LegalMonetaryTotal">
            <let name="prepaidAmount" value="
                    if (not(cbc:PrepaidAmount)) then
                        '0.00'
                    else
                        cbc:PrepaidAmount"/>
            <let name="PayableRoundingAmount" value="
                    if (not(cbc:PayableRoundingAmount)) then
                        '0.00'
                    else
                        cbc:PayableRoundingAmount"/>
            <let name="PaymentInKind" value="
                    if (not(ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:PaymentInKind/puf:Amount)) then
                        '0.00'
                    else
                        ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LegalMonetaryTotalExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LegalMonetaryTotalExtension/puf:PaymentInKind/puf:Amount"/>
            <let name="TaxInclusiveAmount" value="cbc:TaxInclusiveAmount"/>
            <let name="PayableAmount" value="cbc:PayableAmount"/>
            <assert flag="fatal" id="BR-CO-16-PUF-OR001" test="((round((xs:decimal($PayableAmount) - xs:decimal($PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal($TaxInclusiveAmount) - xs:decimal($PaymentInKind) - xs:decimal($prepaidAmount)) * 10 * 10) div 100))">[BR-CO-16-PUF-OR001]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) - Paid amount (BT-113) - Payment in kind amount + Rounding amount (BT-114).</assert>
        </rule>

        <!--Existing EN1631 rule BR-S-08 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-S-08-PUF-OR002 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']">
            <assert flag="fatal" id="BR-S-08-PUF-OR002"
                test="
                    every $rate in cbc:Percent
                        satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate])
                        or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt;
                        (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))
                        and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))
                        or (exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate])
                        or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt;
                        (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))
                        and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))"
                >[BR-S-08-PUF-OR002]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "Standard rated", the VAT category taxable amount (BT-116) in a VATBReakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is “Standard rated” and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
        </rule>


        <!--Existing EN1631 rule BR-Z-08 and BR-Z-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-Z-08-PUF-OR003 and BR-Z-10-PUF-OR004 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']">
            <assert flag="fatal" id="BR-Z-08-PUF-OR003"
                test="
                    (exists(//cac:InvoiceLine)
                    and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount)))))
                    or (exists(//cac:CreditNoteLine)
                    and (xs:decimal(../cbc:TaxableAmount)
                    = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'Z']/xs:decimal(cbc:Amount)))))"
                >[BR-Z-08-PUF-OR003]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amount (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Zero rated".</assert>
            <assert flag="fatal" id="BR-Z-10-PUF-OR004" test="not((cbc:TaxExemptionReason) or (cbc:TaxExemptionReasonCode))">[BR-Z-10-PUF-OR004]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Zero rated" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</assert>
        </rule>

        <!--Existing EN1631 rule BR-E-08 and BR-E-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-E-08-PUF-OR005 and BR-E-10-PUF-OR006 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']">
            <assert flag="fatal" id="BR-E-08-PUF-OR005"
                test="
                    (exists(//cac:InvoiceLine)
                    and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount)))))
                    or (exists(//cac:CreditNoteLine)
                    and (xs:decimal(../cbc:TaxableAmount)
                    = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'E']/xs:decimal(cbc:Amount)))))"
                >[BR-E-08-PUF-OR005]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Exempt from VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Exempt from VAT".</assert>
            <assert flag="fatal" id="BR-E-10-PUF-OR006" test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">[BR-E-10-PUF-OR006]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).    </assert>
        </rule>

        <!--Existing EN1631 rule BR-G-08 and BR-G-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-G-08-PUF-OR007 and BR-G-10-PUF-OR008 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']">
            <assert flag="fatal" id="BR-G-08-PUF-OR007"
                test="
                    (exists(//cac:InvoiceLine)
                    and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount)))))
                    or (exists(//cac:CreditNoteLine)
                    and (xs:decimal(../cbc:TaxableAmount)
                    = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'G']/xs:decimal(cbc:Amount)))))"
                >[BR-G-08-PUF-OR007]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Export outside the EU".</assert>
            <assert flag="fatal" id="BR-G-10-PUF-OR008" test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">[BR-G-10-PUF-OR008]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Export outside the EU" shall have a VAT exemption reason code (BT-121), meaning "Export outside the EU" or the VAT exemption reason text (BT-120) "Export outside the EU" (or the equivalent standard text in another language).</assert>
        </rule>

        <!--Existing EN1631 rule BR-IC-08 and BR-IC-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-IC-08-PUF-OR009 and BR-IC-10-PUF-OR010 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']">
            <assert flag="fatal" id="BR-IC-08-PUF-OR009"
                test="
                    (exists(//cac:InvoiceLine)
                    and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount)))))
                    or (exists(//cac:CreditNoteLine)
                    and (xs:decimal(../cbc:TaxableAmount)
                    = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'K']/xs:decimal(cbc:Amount)))))"
                >[BR-IC-08-PUF-OR009]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Intra-community supply".</assert>
            <assert flag="fatal" id="BR-IC-10-PUF-OR010" test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">[BR-IC-10-PUF-OR010]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Intra-community supply" shall have a VAT exemption reason code (BT-121), meaning "Intra-community supply" or the VAT exemption reason text (BT-120) "Intra-community supply" (or the equivalent standard text in another language).</assert>
        </rule>

        <!--Existing EN1631 rule BR-O-08 and BR-O-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-O-08-PUF-OR011 and BR-O-10-PUF-OR012 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']">
            <assert flag="fatal" id="BR-O-08-PUF-OR011"
                test="
                    (exists(//cac:InvoiceLine)
                    and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount)))))
                    or (exists(//cac:CreditNoteLine)
                    and (xs:decimal(../cbc:TaxableAmount)
                    = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:Amount)))))"
                >[BR-O-08-PUF-OR011]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Not subject to VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Not subject to VAT".</assert>
            <assert flag="fatal" id="BR-O-10-PUF-OR012" test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode))">[BR-O-10-PUF-OR012]-A VAT breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</assert>
        </rule>

        <!--Existing EN1631 rule BR-IG-08 and BR-IG-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-IG-08-PUF-OR013 and BR-IG-10-PUF-OR014 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']">
            <assert flag="fatal" id="BR-IG-08-PUF-OR013"
                test="
                    every $rate in xs:decimal(cbc:Percent)
                        satisfies ((exists(//cac:InvoiceLine)
                        and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))
                        and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))
                        or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))
                        and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))"
                >[BR-IG-08-PUF-OR013]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IGIC", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IGIC" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
            <assert flag="fatal" id="BR-IG-10-PUF-OR014" test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">[BR-IG-10-PUF-OR014]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IGIC" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).    </assert>
        </rule>

        <!--Existing EN1631 rule BR-IP-08 and BR-IP-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-IP-08-PUF-OR015 and BR-IP-10-PUF-OR016 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']">
            <assert flag="fatal" id="BR-IP-08-PUF-OR015"
                test="
                    every $rate in xs:decimal(cbc:Percent)
                        satisfies ((exists(//cac:InvoiceLine)
                        and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))
                        and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))
                        or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))
                        and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:LineExtensionAmount))
                        + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))
                        - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))"
                >[BR-IP-08-PUF-OR015]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IPSI", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IPSI" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</assert>
            <assert flag="fatal" id="BR-IP-10-PUF-OR016" test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">[BR-IP-10-PUF-OR016]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IPSI" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).     </assert>
        </rule>

        <!--Existing EN1631 rule BR-AE-08 and BR-AE-10 refactored to not check cac:TaxTotal/cac:TaxSubTotal on line level, new rule BR-AE-08-PUF-OR017 and BR-AE-10-PUF-OR018 exlude check of line level-->
        <rule context="ubl-invoice:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT'] | ubl-creditnote:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']">
            <assert flag="fatal" id="BR-AE-08-PUF-OR017"
                test="
                    (exists(//cac:InvoiceLine)
                    and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount)))))
                    or (exists(//cac:CreditNoteLine)
                    and (xs:decimal(../cbc:TaxableAmount)
                    = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:LineExtensionAmount))
                    + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = true()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount))
                    - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator = false()][cac:TaxCategory/normalize-space(cbc:ID) = 'AE']/xs:decimal(cbc:Amount)))))"
                >[BR-AE-08-PUF-OR017]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Reverse charge".</assert>
            <assert flag="fatal" id="BR-AE-10-PUF-OR018" test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">[BR-AE-10-PUF-OR018]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Reverse charge" shall have a VAT exemption reason code (BT-121), meaning "Reverse charge" or the VAT exemption reason text (BT-120) "Reverse charge" (or the equivalent standard text in another language).</assert>
        </rule>

        <rule context="cac:InvoiceLine/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LineExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LineExtension/puf:LineExclAllowanceChargeAmount | cac:CreditNoteLine/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:LineExtension']/ext:ExtensionContent/puf:PageroExtension/puf:LineExtension/puf:LineExclAllowanceChargeAmount">
            <assert flag="fatal" id="PUF-R101" test="@currencyID = //cbc:DocumentCurrencyCode">[PUF-R101]-Line exclusive allowance and charge amount currency MUST not differ from document currency.</assert>
        </rule>

        <rule context="cac:InvoiceLine/cac:Price/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PriceExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PriceExtension/puf:PriceInclAllowanceChargeAmount | cac:CreditNoteLine/cac:Price/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:pagero:ExtensionComponent:1.0:PageroExtension:PriceExtension']/ext:ExtensionContent/puf:PageroExtension/puf:PriceExtension/puf:PriceInclAllowanceChargeAmount">
            <assert flag="fatal" id="PUF-R102" test="@currencyID = //cbc:DocumentCurrencyCode">[PUF-R102]-Price including allowance charge amount currency MUST not differ from document currency.</assert>
        </rule>

        <rule context="cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal | cac:CreditNoteLine/cac:TaxTotal/cac:TaxSubtotal">
            <assert flag="fatal" id="PUF-R103" test="cac:TaxCategory/cbc:Percent">[PUF-R103]-If Tax Subtotal exist on line, tax category percent MUST exist.</assert>
            <assert flag="fatal" id="PUF-R104" test="cac:TaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:ID">[PUF-R104]-If Tax Subtotal exist on line, VAT category ID MUST exist.</assert>
        </rule>

    </pattern>

</schema>
