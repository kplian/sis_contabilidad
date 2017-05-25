<?php
/**
*@package pXP
*@file gen-ACTTipoRelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:51:43
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTTipoRelacionContable extends ACTbase{    
			
	function listarTipoRelacionContable(){
		$this->objParam->defecto('ordenacion','id_tipo_relacion_contable');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('id_tabla_relacion_contable')!=''){
			$this->objParam->addFiltro("tiprelco.id_tabla_relacion_contable = ".$this->objParam->getParametro('id_tabla_relacion_contable'));
		}
		
		if($this->objParam->getParametro('es_general')=='si') {
            $this->objParam->addFiltro("tiprelco.id_tabla_relacion_contable is NULL");	    
        }      	
        
		//filtro por tabla
		if($this->objParam->getParametro('nombre_tabla')!='') {
            $this->objParam->addFiltro("lower (tabrelco.esquema) || ''.'' || lower (tabrelco.tabla)  = ''" . $this->objParam->getParametro('nombre_tabla')."''" );    
        }
		//filtro por codigos tipo relacion
		if($this->objParam->getParametro('codigos_tipo_relacion')!='') {
            $this->objParam->addFiltro("codigo_tipo_relacion IN (" . $this->objParam->getParametro('codigos_tipo_relacion') . ")");    
        }
				
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODTipoRelacionContable','listarTipoRelacionContable');
		} else{
			$this->objFunc=$this->create('MODTipoRelacionContable');
			
			$this->res=$this->objFunc->listarTipoRelacionContable($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarTipoRelacionContable(){
		$this->objFunc=$this->create('MODTipoRelacionContable');	
		if($this->objParam->insertar('id_tipo_relacion_contable')){
			$this->res=$this->objFunc->insertarTipoRelacionContable($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarTipoRelacionContable($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarTipoRelacionContable(){
			$this->objFunc=$this->create('MODTipoRelacionContable');	
		$this->res=$this->objFunc->eliminarTipoRelacionContable($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>