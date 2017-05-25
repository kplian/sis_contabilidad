<?php
/**
*@package pXP
*@file gen-ACTIntRelDevengado.php
*@author  (admin)
*@date 09-10-2015 12:31:01
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTIntRelDevengado extends ACTbase{    
			
	function listarIntRelDevengado(){
		$this->objParam->defecto('ordenacion','id_int_rel_devengado');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		
		if($this->objParam->getParametro('id_int_comprobante_pago')!=''){
			$this->objParam->addFiltro("id_int_comprobante_pago = ".$this->objParam->getParametro('id_int_comprobante_pago'));	
		}
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODIntRelDevengado','listarIntRelDevengado');
		} else{
			$this->objFunc=$this->create('MODIntRelDevengado');
			
			$this->res=$this->objFunc->listarIntRelDevengado($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarIntRelDevengado(){
		$this->objFunc=$this->create('MODIntRelDevengado');	
		if($this->objParam->insertar('id_int_rel_devengado')){
			$this->res=$this->objFunc->insertarIntRelDevengado($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarIntRelDevengado($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarIntRelDevengado(){
			$this->objFunc=$this->create('MODIntRelDevengado');	
		$this->res=$this->objFunc->eliminarIntRelDevengado($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>