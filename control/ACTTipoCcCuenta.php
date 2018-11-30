<?php
/**
*@package pXP
*@file gen-ACTTipoCcCuenta.php
*@author  (admin)
*@date 08-09-2017 19:16:00
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoCcCuenta extends ACTbase{    
			
	function listarTipoCcCuenta(){
		$this->objParam->defecto('ordenacion','id_tipo_cc_cuenta');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_tipo_cc')!=''){
            $this->objParam->addFiltro("tcau.id_tipo_cc = ".$this->objParam->getParametro('id_tipo_cc'));    
        }
		
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoCcCuenta','listarTipoCcCuenta');
		} else{
			$this->objFunc=$this->create('MODTipoCcCuenta');
			
			$this->res=$this->objFunc->listarTipoCcCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoCcCuenta(){
		$this->objFunc=$this->create('MODTipoCcCuenta');	
		if($this->objParam->insertar('id_tipo_cc_cuenta')){
			$this->res=$this->objFunc->insertarTipoCcCuenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoCcCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoCcCuenta(){
			$this->objFunc=$this->create('MODTipoCcCuenta');	
		$this->res=$this->objFunc->eliminarTipoCcCuenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>