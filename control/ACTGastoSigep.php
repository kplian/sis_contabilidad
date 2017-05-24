<?php
/**
*@package pXP
*@file gen-ACTGastoSigep.php
*@author  (gsarmiento)
*@date 08-05-2017 20:06:08
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

include_once(dirname(__FILE__).'/../../lib/lib_general/ExcelInput.php');

class ACTGastoSigep extends ACTbase{    
			
	function listarGastoSigep(){
		$this->objParam->defecto('ordenacion','id_gasto_sigep');
		$this->objParam->defecto('dir_ordenacion','asc');

		if($this->objParam->getParametro('id_archivo_sigep')!=''){
			$this->objParam->addFiltro("gtsg.id_archivo_sigep = ".$this->objParam->getParametro('id_archivo_sigep'));
		}

		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODGastoSigep','listarGastoSigep');
		} else{
			$this->objFunc=$this->create('MODGastoSigep');
			
			$this->res=$this->objFunc->listarGastoSigep($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarGastoSigep(){
		$this->objFunc=$this->create('MODGastoSigep');	
		if($this->objParam->insertar('id_gasto_sigep')){
			$this->res=$this->objFunc->insertarGastoSigep($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarGastoSigep($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarGastoSigep(){
			$this->objFunc=$this->create('MODGastoSigep');	
		$this->res=$this->objFunc->eliminarGastoSigep($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}

	function subirGastoSigep(){
		//validar extnsion del archivo
		//$id_cuenta_bancaria = $this->objParam->getParametro('id_cuenta_bancaria');
		$codigoArchivo = $this->objParam->getParametro('codigo');

		$arregloFiles = $this->objParam->getArregloFiles();
		$ext = pathinfo($arregloFiles['archivo']['name']);
		$nombreArchivo = $ext['filename'];
		$extension = $ext['extension'];

		$error = 'no';
		$mensaje_completo = '';
		//validar errores unicos del archivo: existencia, copia y extension
		if(isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])){
			/*
                        if (!in_array($extension, array('xls','xlsx','XLS','XLSX'))){
                            $mensaje_completo = "La extensión del archivo debe ser XLS o XLSX";
                            $error = 'error_fatal';
                        }else {*/
			//procesa Archivo
			$archivoExcel = new ExcelInput($arregloFiles['archivo']['tmp_name'], $codigoArchivo);
			$archivoExcel->recuperarColumnasExcel();

			$arrayArchivo = $archivoExcel->leerColumnasArchivoExcel();
			//var_dump($arrayArchivo); exit;
			foreach ($arrayArchivo as $fila) {
				$this->objParam->addParametro('gestion', $fila['gestion']);
				$this->objParam->addParametro('objeto', $fila['objeto']);
				$this->objParam->addParametro('descripcion_gasto', $fila['descripcion_gasto']);
				$this->objParam->addParametro('fuente', $fila['fuente'] == NULL ? 0 : $fila['fuente']);
				$this->objParam->addParametro('organismo', $fila['organismo'] == NULL ? 0 : $fila['organismo']);
				$this->objParam->addParametro('programa', $fila['programa'] == NULL ? 0 : $fila['programa']);
				$this->objParam->addParametro('proyecto', $fila['proyecto'] == NULL ? 0 : $fila['proyecto']);
				$this->objParam->addParametro('actividad', $fila['actividad'] == NULL ? 0 : $fila['actividad']);
				$this->objParam->addParametro('nro_preventivo', $fila['nro_preventivo'] == NULL ? 0 : $fila['nro_preventivo']);
				$this->objParam->addParametro('nro_comprometido', $fila['nro_comprometido'] == NULL ? 0 : $fila['nro_comprometido']);
				$this->objParam->addParametro('nro_devengado', $fila['nro_devengado'] == NULL ? 0 : $fila['nro_devengado']);
				$this->objParam->addParametro('entidad_transferencia', $fila['entidad_transferencia'] == NULL ? 0 : $fila['entidad_transferencia']);
				$this->objParam->addParametro('monto', $fila['monto'] == NULL ? 0.00 : $fila['monto']);
				$this->objParam->addParametro('estado', $fila['estado'] == NULL ? '' : $fila['estado']);
				$this->objFunc = $this->create('sis_contabilidad/MODGastoSigep');
				$this->res = $this->objFunc->insertarGastoSigep($this->objParam);
				if($this->res->getTipo()=='ERROR'){
					$error = 'error';
					$mensaje_completo = "Error al guardar el fila en tabla ". $this->res->getMensajeTec();
				}
			}

			//upload directory
			$upload_dir = "../../../sis_contabilidad/archivos/";
			//create file name
			$file_path = $upload_dir . $arregloFiles['archivo']['name'];

			//move uploaded file to upload dir
			if (!move_uploaded_file($arregloFiles['archivo']['tmp_name'], $file_path)) {
				//error moving upload file
				$mensaje_completo = "Error al guardar el archivo en disco";
				$error = 'error_fatal';
			}else{
				$this->objParam->addParametro('nombre_archivo', $nombreArchivo);
				$this->objParam->addParametro('extension', $extension);
				$this->objParam->addParametro('url', $file_path);
				$this->objFunc = $this->create('sis_contabilidad/MODArchivoSigep');
				$this->res = $this->objFunc->insertarArchivoSigep($this->objParam);
				if($this->res->getTipo()=='ERROR'){
					$error = 'error';
					$mensaje_completo = "Error al guardar el archivo en la tabla ". $this->res->getMensajeTec();
				}
			}
			// }
		} else {
			$mensaje_completo = "No se subio el archivo a la carpeta temporal";
			$error = 'error_fatal';
		}
		//armar respuesta en error fatal
		if ($error == 'error_fatal') {

			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('ERROR','ACTGastoSigep.php',$mensaje_completo,
					$mensaje_completo,'control');
			//si no es error fatal proceso el archivo
		} else {
			$lines = file($file_path);
		}
		//armar respuesta en caso de exito o error en algunas tuplas
		if ($error == 'error') {
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('ERROR','ACTGastoSigep.php','Ocurrieron los siguientes errores : ' . $mensaje_completo,
					$mensaje_completo,'control');
		} else if ($error == 'no') {
			$this->mensajeRes=new Mensaje();
			$this->mensajeRes->setMensaje('EXITO','ACTGastoSigep.php','El archivo fue ejecutado con éxito',
					'El archivo fue ejecutado con éxito','control');
		}

		//devolver respuesta
		$this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());
		//return $this->respuesta;
	}
}

?>