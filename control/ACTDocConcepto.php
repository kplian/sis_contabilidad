<?php
/**
*@package pXP
*@file gen-ACTDocConcepto.php
*@author  (admin)
*@date 15-09-2015 13:09:45
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTDocConcepto extends ACTbase{    
			
	function listarDocConcepto(){
		$this->objParam->defecto('ordenacion','id_doc_concepto');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_doc_compra_venta')!=''){
			$this->objParam->addFiltro("docc.id_doc_compra_venta = ".$this->objParam->getParametro('id_doc_compra_venta'));	
		}
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODDocConcepto','listarDocConcepto');
		} else{
			$this->objFunc=$this->create('MODDocConcepto');
			
			$this->res=$this->objFunc->listarDocConcepto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarDocConcepto(){
		$this->objFunc=$this->create('MODDocConcepto');	
		if($this->objParam->insertar('id_doc_concepto')){
			$this->res=$this->objFunc->insertarDocConcepto($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarDocConcepto($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	function eliminarDocConcepto(){
		$this->objFunc=$this->create('MODDocConcepto');	
		$this->res=$this->objFunc->eliminarDocConcepto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function verificarRelacionConcepto(){
		$this->objFunc=$this->create('MODDocConcepto');	
		$this->res=$this->objFunc->verificarRelacionConcepto($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

   
			
}

?>