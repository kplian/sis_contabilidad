<?php
/**
*@package pXP
*@file gen-ACTTipoCostoCuenta.php
*@author  (admin)
*@date 30-12-2016 20:29:17
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoCostoCuenta extends ACTbase{    
			
	function listarTipoCostoCuenta(){
		$this->objParam->defecto('ordenacion','id_tipo_costo_cuenta');
        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('id_tipo_costo') != '') {
            $this->objParam->addFiltro(" coc.id_tipo_costo = " . $this->objParam->getParametro('id_tipo_costo'));
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoCostoCuenta','listarTipoCostoCuenta');
		} else{
			$this->objFunc=$this->create('MODTipoCostoCuenta');
			
			$this->res=$this->objFunc->listarTipoCostoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoCostoCuenta(){
		$this->objFunc=$this->create('MODTipoCostoCuenta');	
		if($this->objParam->insertar('id_tipo_costo_cuenta')){
			$this->res=$this->objFunc->insertarTipoCostoCuenta($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoCostoCuenta($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoCostoCuenta(){
			$this->objFunc=$this->create('MODTipoCostoCuenta');	
		$this->res=$this->objFunc->eliminarTipoCostoCuenta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function listarCuentas(){
        $this->objParam->defecto('ordenacion','id_cuenta');
        $this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_cuenta') != '') {
            $this->objParam->addFiltro(" cta.id_cuenta = " . $this->objParam->getParametro('id_cuenta'));
        }
        $this->objFunc=$this->create('MODTipoCostoCuenta');
        $this->res=$this->objFunc->listarCuentas($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

			
}

?>