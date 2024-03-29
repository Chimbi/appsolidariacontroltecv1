import 'dart:convert';
import 'package:appsolidariacontroltecv1/model/amparoModel.dart';
import 'package:appsolidariacontroltecv1/model/auxiliarModel.dart';
import 'package:flutter/foundation.dart';

Poliza polizaFromJson(String str) {
  final jsonData = json.decode(str);
  return Poliza.fromMap(jsonData);
}

String polizaToJson(Poliza data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Poliza with ChangeNotifier{

  ///Controles Técnicos
  int controlFechaEmision;
  int differenceInDays;
  int controlDelegacion;
  int controlCupoDisp;
  Map<String,int> controlFechaAmparo = Map();
  Map<String,int> controlTasaAmparo = Map();
  Map<String,int> controlPorcentajeAmparo = Map();
  int totalAutorizaciones;

  int issueExpense;
  int filledState;
  String tipoImpresion;

  ///NOT IN THE FORM
  Auxiliar intermediary;
  Auxiliar policyBuyer;
  Auxiliar contractor;
  Auxiliar beneficiary;


  //version 1: 1 Intermediario version2: varios intermediarios
  //double comision;  //Porcentaje de comisión se utiliza cuando hay varios intermediarios

  //Ramo comercial
  String insuranceBranch = "Cumplimiento";


  //Tipo de movimiento: Tipos de anexos. Espedicion
  //TODO definir que campos van a nivel de anexo y separarlos en un objeto aparte

  //Afianzado afianzado;
  //version 1: 1 Afianzado version2: varios afianzados


//TODO Añadir mas tomadores para Consorcio o temporal. el de mayor participacion es el tomador si no hay nit ni nombre

  ///title: Caracteristicas de la póliza
  DateTime issueDate = DateTime.now(); //Not in the form
  String policyInitialDate; //In the form as Date field Vigencia desde hora desde 00:00
  String policyFinalDate;  //Not in the form TODO 1. Calcular con la máxima fecha de los amparos
  int avaliableQuota;


  String currency = "Pesos"; //Not in the form
  //Cobra iva siempre
  String productConditions; //Dropdown in the form "Clausulado1: "Lorem ipsum", "Clausulado2":"Lorem ipsum2", "Clausuado3":"Lorem ipsum3"
  String textProdConditions;
  String operationType = "100% Compañia";  //NOT IN THE FORM 100% Compañia, Coaseguro Cedido, Coaseguro Aceptado //Incluir en el modelo List<CiasSeguros>
  String polizaType;  // DropdownFormField "Particular, Estatal, Servicios Publicos Domiciliarios, Poliza Ecopetrol, Empresas públicas con régimen privado"
  String businessType;
  //Tipo de Negocio: Contrato, contrato de arrendamiento, contrato de consultoria,
  //contrato de ejecucion de obra, contrato de interventoria, contrato de prestacion de servicios

//--------  Se notifica el temporario con esta informacion ---------------------------------------

  int temporaryNumber = 5678; //TODO Revisar la cantidad the caracteres
  int polizaNumber = 1234; //TODO Revisar la cantidad the caracteres

  ///Information of the contractor treaty
  String treatyNumber;
  double treatyValue;  //Nivel anexo
  int excecutionTime;   //En años
  String treatyInitialDate;  //Asignar a vigDesde
  String insuranceObject;  //Contrato, Orden compra, Orden servicio, Orden suministro, Factura venta, Pliego condiciones
  String objectText;
  String aclaratoryText; //Ver como funciona con un texto largo TODO crear en formulario

  ///Coverages

  List<Amparo> covers = [];

  ///This list should be filled with the end dates of every cover
  ///The highest date should be asigned to the policyFinalDate
  List<DateTime> listDatesCovers = List();
  Map<int,DateTime> mapDateCovers = Map();


  //int poliza;  //Consecutivo sistema, revisar si se necesita
  ///This is used to know the issue state of the policy: 1. Draft, 2. Revision, 3.Issued
  int issueState = 1; //1 Borrador 2. Revision 3. Emision


  //int retroactividad;

  ///Valores totales de la póliza
  double insuranceTotalValue;
  double totalPremium;  //The total premium is the sum of all coverages premium
  double comisionValue; //This is calculated multipling the comision rate by the premium by coverage
  double porcIVA;
  double ivaTotal;
  double totalPayment;

  void initPoliza(){

  }

  Poliza({this.totalAutorizaciones, this.controlDelegacion, this.controlCupoDisp,this.controlFechaEmision, this.porcIVA, this.issueExpense, this.tipoImpresion, this.listDatesCovers, this.intermediary,this.policyBuyer,this.contractor,this.beneficiary,
    this.avaliableQuota,this.insuranceBranch, this.issueDate, this.policyInitialDate, this.policyFinalDate,
    this.currency, this.productConditions, this.textProdConditions, this.operationType,
    this.polizaType, this.businessType, this.temporaryNumber,
    this.polizaNumber, this.treatyNumber,
    this.treatyValue, this.excecutionTime, this.treatyInitialDate,
    this.insuranceObject, this.aclaratoryText, this.objectText, this.covers, this.issueState,
    this.insuranceTotalValue, this.totalPremium, this.comisionValue, this.filledState, this.mapDateCovers});

  factory Poliza.fromMap(Map<String, dynamic> json) => new Poliza(
      intermediary: json["intermediario"], policyBuyer:  json["afianzado"], contractor:  json["contratante"],
      avaliableQuota: json["cupoDisponible"], beneficiary: json["beneficiario"], insuranceBranch: json["descRamo"], issueDate: json["fechaEmision"],
      policyInitialDate: json["vigDesde"], policyFinalDate: json["vigHasta"], currency: json["tipoCambio"],
      productConditions: json["productoClausulado"],textProdConditions: json["textoClausulado"],
      operationType: json["descTipoOperacion"], polizaType: json["descTipoPoliza"],
      businessType: json["descTipoNegocio"], temporaryNumber: json["temporario"], polizaNumber: json["numPoliza"],
      treatyNumber: json["numeroContrato"],
      treatyValue: json["valorContrato"], excecutionTime: json["plazoEjecucion"], treatyInitialDate: json["fechaFinContrato"],
      insuranceObject: json["objetoSeguro"], aclaratoryText: json["textoAclaratorio"], objectText: json["objectText"],
      covers: json["amparos"], issueState: json["estado"], insuranceTotalValue: json["valAsegTotal"],
      totalPremium: json["primaTotal"], comisionValue: json["valComision"]
  );

  Map<String, dynamic> toMap() => {

    "intermediarioId" : intermediary.toMap(), "afianzadoId" : policyBuyer.toMap(), "contratanteId" : contractor.toMap(),
    "cupoDisponible": avaliableQuota,"beneficiarioId": beneficiary?.id, "descRamo" : insuranceBranch ,
    "fechaEmision": issueDate, "vigDesde": policyInitialDate, "vigHasta": policyFinalDate,
    "tipoCambio": currency, "productoClausulado": productConditions, "textoClausulado":textProdConditions, "descTipoOperacion": operationType,
    "descTipoPoliza": polizaType, "descTipoNegocio": businessType, "temporario": temporaryNumber,
    "numPoliza": polizaNumber, "numeroContrato": treatyNumber,
    "valorContrato": treatyValue, "plazoEjecucion": excecutionTime, "fechaFinContrato": treatyInitialDate,
    "objetoSeguro": insuranceObject, "textoAclaratorio": aclaratoryText, "objectText" : objectText, "estado": issueState,  //, "amparos": covers
    "valAsegTotal": insuranceTotalValue, "primaTotal": totalPremium, "valComision": comisionValue,
  };



  @override
  String toString() {
    return 'PolicyInitialDate: $policyInitialDate, PolicyFinalDate $policyFinalDate, listDateCover: ${listDatesCovers.toString()}, Intermediarie: $intermediary, PolicyBuyer: $policyBuyer, Contractor: $contractor, Beneficiary: $beneficiary,'
        'AvaliableQuota: $avaliableQuota, _InsuranceBranch: $insuranceBranch, IssueDate: $issueDate, ExchangeRate: $currency, ProdConditions: $productConditions, TextProdConditions: $textProdConditions, OperationType: $operationType,'
        'PolicyType: $polizaType, BusinessType: $businessType, TemporaryNumber: $temporaryNumber,'
        'PolicyNumber: $polizaNumber, TreatyNumber: $treatyNumber,'
        'TreatyValue: $treatyValue, ExecutionTime: $excecutionTime, TreatyEndDateContract: $treatyInitialDate,'
        'InsuranceObject: $insuranceObject, AclaratoryText: $aclaratoryText, Object Text: $objectText, PolicyIssueState: $issueState,'
        'TotalInsuranceValue: $insuranceTotalValue, TotalPremium: $totalPremium, ComisionValue: $comisionValue, Covers:---$covers,';
  }

}

