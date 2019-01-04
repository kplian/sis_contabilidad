<?php
/**
*@package pXP
*@file gen-ACTTipoRelacionContable.php
*@author  (admin)
*@date 16-05-2013 21:51:43
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 	ISSUE			FECHA				AUTHOR 			DESCRIPCION
    #14	endeEtr 	04/01/2019			EGS				se agrego las funciones exportarDatos() y crearArchivoExportacion() para la exportacion de configuracion	
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
		
		//filtro por codigos tipo relacion
		if($this->objParam->getParametro('id_tipo_relacion_contable')!='') {
            $this->objParam->addFiltro("id_tipo_relacion_contable IN (" . $this->objParam->getParametro('id_tipo_relacion_contable') . ")");    
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
	function exportarDatos(){//#14	04/01/2019	EGS		
		
		//crea el objetoFunProcesoMacro que contiene todos los metodos del sistema de workflow
		if($this->objParam->getParametro('id_tipo_relacion_contable')!='') {
            $this->objParam->addFiltro("tiprelco.id_tipo_relacion_contable = ". $this->objParam->getParametro('id_tipo_relacion_contable'));    
        }  
		$this->objFunProcesoMacro=$this->create('MODTipoRelacionContable');		

		$this->res = $this->objFunProcesoMacro->exportarDatos();
		
		if($this->res->getTipo()=='ERROR'){
			$this->res->imprimirRespuesta($this->res->generarJson());
			exit;
		}
		
		$nombreArchivo = $this->crearArchivoExportacion($this->res);
		
		$this->mensajeExito=new Mensaje();
		$this->mensajeExito->setMensaje('EXITO','Reporte.php','Se genero con exito el sql'.$nombreArchivo,
										'Se genero con exito el sql'.$nombreArchivo,'control');
		$this->mensajeExito->setArchivoGenerado($nombreArchivo);
		
		$this->res->imprimirRespuesta($this->mensajeExito->generarJson());

	}
	
	function crearArchivoExportacion($res) {//#14	04/01/2019	EGS	
		$data = $res -> getDatos();
		$fileName = uniqid(md5(session_id()).'TablaRelacionContable').'.sql';
		//create file
		$file = fopen("../../../reportes_generados/$fileName", 'w');
		
		$sw_gui = 0;
		$sw_funciones=0;
		$sw_procedimiento=0;
		$sw_rol=0; 
		$sw_rol_pro=0;
		fwrite ($file,"----------------------------------\r\n".
						  "--COPY LINES TO SUBSYSTEM data.sql FILE  \r\n".
						  "---------------------------------\r\n".
						  "\r\n" );
		foreach ($data as $row) {			
		    if ($row['tipo_reg'] == 'tipo_relacion') {
				if ($row['estado_reg'] == 'inactivo') {
						
					fwrite ($file, 
					"select param.f_import_ttipo_relacion_contable ('delete','".							 
							$row['codigo_tabla']."',
							NULL,NULL,NULL,NULL,NULL,
							NULL,NULL,NULL,NULL,NULL,NULL,NULL);\r\n");	
	
			} else {
					
					fwrite ($file, 
					 "select conta.f_import_ttipo_relacion_contable ('insert',".
							 (is_null($row['codigo_tipo_relacion'])?'NULL':"'".$row['codigo_tipo_relacion']."'") ."," .
							 (is_null($row['codigo_tabla'])?'NULL':"'".$row['codigo_tabla']."'") ."," .							 
							 (is_null($row['nombre_tipo_relacion'])?'NULL':"'".$row['nombre_tipo_relacion']."'") ."," .
							 (is_null($row['estado_reg'])?'NULL':"'".$row['estado_reg']."'") ."," .
							 (is_null($row['tiene_centro_costo'])?'NULL':"'".$row['tiene_centro_costo']."'") ."," .
							 (is_null($row['tiene_partida'])?'NULL':"'".$row['tiene_partida']."'") ."," .
							 (is_null($row['tiene_auxiliar'])?'NULL':"'".$row['tiene_auxiliar']."'") ."," .
							 (is_null($row['partida_tipo'])?'NULL':"'".$row['partida_tipo']."'") ."," .
							 (is_null($row['partida_rubro'])?'NULL':"'".$row['partida_rubro']."'") ."," .
							 (is_null($row['tiene_aplicacion'])?'NULL':"'".$row['tiene_aplicacion']."'") ."," .	
							 (is_null($row['tiene_moneda'])?'NULL':"'".$row['tiene_moneda']."'") ."," .	
							 (is_null($row['tiene_tipo_centro'])?'NULL':"'".$row['tiene_tipo_centro']."'") ."," .							 
							 (is_null($row['codigo_aplicacion_catalogo'])?'NULL':"'".$row['codigo_aplicacion_catalogo']."'") .");\r\n");
		 						
				}
			} 
         } //end for
		
		
		return $fileName;
	}
			
}

?>