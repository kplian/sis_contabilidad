<?php
/**
*@package pXP
*@file gen-ACTGrupoOt.php
*@author  (admin)
*@date 06-10-2014 14:11:14
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTGrupoOt extends ACTbase{    
			
	function listarGrupoOt(){
		$this->objParam->defecto('ordenacion','id_grupo_ot');

		$this->objParam->defecto('dir_ordenacion','asc');
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODGrupoOt','listarGrupoOt');
		} else{
			$this->objFunc=$this->create('MODGrupoOt');
			
			$this->res=$this->objFunc->listarGrupoOt($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarGrupoOt(){
		$this->objFunc=$this->create('MODGrupoOt');	
		if($this->objParam->insertar('id_grupo_ot')){
			$this->res=$this->objFunc->insertarGrupoOt($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarGrupoOt($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarGrupoOt(){
			$this->objFunc=$this->create('MODGrupoOt');	
		$this->res=$this->objFunc->eliminarGrupoOt($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
			
}

?>