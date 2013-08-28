<?php
/**
*@package pXP
*@file gen-ACTPlantillaCalculo.php
*@author  (admin)
*@date 28-08-2013 19:01:20
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPlantillaCalculo extends ACTbase{    
			
	function listarPlantillaCalculo(){
		$this->objParam->defecto('ordenacion','id_plantilla_calculo');
		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_plantilla')!=''){
			$this->objParam->addFiltro("placal.id_plantilla = ".$this->objParam->getParametro('id_plantilla'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPlantillaCalculo','listarPlantillaCalculo');
		} else{
			$this->objFunc=$this->create('MODPlantillaCalculo');
			
			$this->res=$this->objFunc->listarPlantillaCalculo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPlantillaCalculo(){
		$this->objFunc=$this->create('MODPlantillaCalculo');	
		if($this->objParam->insertar('id_plantilla_calculo')){
			$this->res=$this->objFunc->insertarPlantillaCalculo($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPlantillaCalculo($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPlantillaCalculo(){
			$this->objFunc=$this->create('MODPlantillaCalculo');	
		$this->res=$this->objFunc->eliminarPlantillaCalculo($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>