<?php
/**
*@package pXP
*@file gen-ACTConfigSubtipoCuenta.php
*@author  (admin)
*@date 07-06-2017 19:52:43
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTConfigSubtipoCuenta extends ACTbase{    
			
	function listarConfigSubtipoCuenta(){
		$this->objParam->defecto('ordenacion','id_config_subtipo_cuenta');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_config_tipo_cuenta')!=''){
            $this->objParam->addFiltro("cst.id_config_tipo_cuenta = ".$this->objParam->getParametro('id_config_tipo_cuenta'));    
        }
		
		if($this->objParam->getParametro('tipo_cuenta')!=''){
            $this->objParam->addFiltro("ctc.tipo_cuenta = ''".$this->objParam->getParametro('tipo_cuenta')."''");    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODConfigSubtipoCuenta','listarConfigSubtipoCuenta');
		} else{
			$this->objFunc=$this->create('MODConfigSubtipoCuenta');
			
			$this->res=$this->objFunc->listarConfigSubtipoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarConfigSubtipoCuenta(){
		$this->objFunc=$this->create('MODConfigSubtipoCuenta');	
		if($this->objParam->insertar('id_config_subtipo_cuenta')){
			$this->res=$this->objFunc->insertarConfigSubtipoCuenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarConfigSubtipoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarConfigSubtipoCuenta(){
			$this->objFunc=$this->create('MODConfigSubtipoCuenta');	
		$this->res=$this->objFunc->eliminarConfigSubtipoCuenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>