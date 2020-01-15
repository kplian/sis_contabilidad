<?php
/**
*@package pXP
*@file gen-ACTImpuestoForm.php
*@author  (miguel.mamani)
*@date 29-07-2019 21:50:22
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTImpuestoForm extends ACTbase{    
			
	function listarImpuestoForm(){
		$this->objParam->defecto('ordenacion','id_impuesto_form');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_impuesto_form_padre') != '') {
            $this->objParam->addFiltro("imp.id_impuesto_form_padre = " . $this->objParam->getParametro('id_impuesto_form_padre'));
        }else{
            $this->objParam->addFiltro("imp.id_impuesto_form_padre is null");
        }
        if($this->objParam->getParametro('id_gestion')!=''){
            $this->objParam->addFiltro("imp.id_gestion = ".$this->objParam->getParametro('id_gestion'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODImpuestoForm','listarImpuestoForm');
		} else{
			$this->objFunc=$this->create('MODImpuestoForm');
			
			$this->res=$this->objFunc->listarImpuestoForm($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarImpuestoForm(){
		$this->objFunc=$this->create('MODImpuestoForm');	
		if($this->objParam->insertar('id_impuesto_form')){
			$this->res=$this->objFunc->insertarImpuestoForm($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarImpuestoForm($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarImpuestoForm(){
			$this->objFunc=$this->create('MODImpuestoForm');	
		$this->res=$this->objFunc->eliminarImpuestoForm($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>