<?php
/**
*@package pXP
*@file gen-ACTImpuestoFormPeriodo.php
*@author  (miguel.mamani)
*@date 29-07-2019 21:50:27
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTImpuestoFormPeriodo extends ACTbase{    
			
	function listarImpuestoFormPeriodo(){
		$this->objParam->defecto('ordenacion','id_impuesto_form_periodo');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_impuesto_form') != '') {
            $this->objParam->addFiltro("ifp.id_impuesto_form = " . $this->objParam->getParametro('id_impuesto_form'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODImpuestoFormPeriodo','listarImpuestoFormPeriodo');
		} else{
			$this->objFunc=$this->create('MODImpuestoFormPeriodo');
			
			$this->res=$this->objFunc->listarImpuestoFormPeriodo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarImpuestoFormPeriodo(){
		$this->objFunc=$this->create('MODImpuestoFormPeriodo');	
		if($this->objParam->insertar('id_impuesto_form_periodo')){
			$this->res=$this->objFunc->insertarImpuestoFormPeriodo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarImpuestoFormPeriodo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarImpuestoFormPeriodo(){
			$this->objFunc=$this->create('MODImpuestoFormPeriodo');	
		$this->res=$this->objFunc->eliminarImpuestoFormPeriodo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>