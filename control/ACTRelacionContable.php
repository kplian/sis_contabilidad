<?php
/**
*@package pXP
*@file gen-ACTRelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:52:14
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTRelacionContable extends ACTbase{    
			
	function listarRelacionContable(){
		$this->objParam->defecto('ordenacion','id_relacion_contable');

		$this->objParam->defecto('dir_ordenacion','asc');
		
		if($this->objParam->getParametro('id_tipo_relacion_contable')!=''){
		     
		    
           $this->objParam->addFiltro("tiprelco.id_tipo_relacion_contable = ".$this->objParam->getParametro('id_tipo_relacion_contable'));
                
		}
		
		if($this->objParam->getParametro('id_tabla')!=''){
            $this->objParam->addFiltro(" (relcon.id_tabla = ".$this->objParam->getParametro('id_tabla')." or relcon.id_tabla is NULL)");    
        }
		
		if($this->objParam->getParametro('nombre_tabla')!='') {
            $this->objParam->addFiltro("lower (tabrelco.esquema) || ''.'' || lower (tabrelco.tabla)  = ''" . $this->objParam->getParametro('nombre_tabla')."''" );    
        }
		
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODRelacionContable','listarRelacionContable');
		} else{
			$this->objFunc=$this->create('MODRelacionContable');
			
			$this->res=$this->objFunc->listarRelacionContable($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarRelacionContable(){
		$this->objFunc=$this->create('MODRelacionContable');	
		if($this->objParam->insertar('id_relacion_contable')){
			$this->res=$this->objFunc->insertarRelacionContable($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarRelacionContable($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarRelacionContable(){
			$this->objFunc=$this->create('MODRelacionContable');	
		$this->res=$this->objFunc->eliminarRelacionContable($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

    function clonarConfig(){
		$this->objFunc=$this->create('MODRelacionContable');	
		$this->res=$this->objFunc->clonarConfig($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
	
	/*
	 *   Auto:  RAC
	 *   Desc:  Recuepra los departamentos delibro de bancos asociados al departamento contable
	 * 
	 * */
	
	function getDlbXDconta(){
		$this->objFunc=$this->create('MODRelacionContable');	
		$this->res=$this->objFunc->getDlbXDconta($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>