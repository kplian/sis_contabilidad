<?php
/**
 *@package pXP
 *@file gen-ACTDeclaracionesJuridicas.php
 *@author  (m.mamani)
 *@date 27-08-2018 14:51:02
 *@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
 */

class ACTDeclaracionesJuridicas extends ACTbase{

    function listarDeclaracionesJuridicas(){
        $this->objParam->defecto('ordenacion','id_declaracion_juridica');
        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('id_periodo') != ''){
            $this->objParam->addFiltro("djs.id_periodo = ".$this->objParam->getParametro('id_periodo'));
        }
        if($this->objParam->getParametro('tipo')!=''){

            $this->objParam->addFiltro("djs.tipo = "."''".$this->objParam->getParametro('tipo')."''");
        }
        if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
            $this->objReporte = new Reporte($this->objParam,$this);
            $this->res = $this->objReporte->generarReporteListado('MODDeclaracionesJuridicas','listarDeclaracionesJuridicas');
        } else{
            $this->objFunc=$this->create('MODDeclaracionesJuridicas');

            $this->res=$this->objFunc->listarDeclaracionesJuridicas($this->objParam);
        }
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function subirArchivo(){

        $arregloFiles = $this->objParam->getArregloFiles();
        $ext = pathinfo($arregloFiles['archivo']['name']);
        $extension = $ext['extension'];
        $error = 'no';
        $mensaje_completo = '';

        //Valida extencio
        //Validar errores del archivo
        if (isset($arregloFiles['archivo']) && is_uploaded_file($arregloFiles['archivo']['tmp_name'])) {
            if ($extension != 'csv' && $extension != 'CSV') {
                $mensaje_completo = "La extensión del archivo debe ser CSV";
                $error = 'error_fatal';
            }
            $upload_dir = "/tmp/";
            $file_path = $upload_dir . $arregloFiles['archivo']['name'];
            if (!move_uploaded_file($arregloFiles['archivo']['tmp_name'], $file_path)) {
                $mensaje_completo = "Error al guardar el archivo csv en disco";
                $error = 'error_fatal';
            }
        } else {
            $mensaje_completo = "No se subio el archivo";
            $error = 'error_fatal';
        }
        //armar respuesta en error fatal
        if ($error == 'error_fatal') {
            $this->mensajeRes = new Mensaje();
            $this->mensajeRes->setMensaje('ERROR', 'ACTDeclaracionesJuridicas.php', $mensaje_completo, $mensaje_completo, 'control');
            //si no es error fatal proceso el archivo
        } else {
            $lines = file($file_path);
            foreach ($lines as $line_num => $line) {
                $line = str_replace("'", "", $line);
                $arr_temp = explode('|', $line);
                //var_dump($arr_temp);exit;
                $this->objParam->addParametro('fila', $arr_temp[0]);
                /// $text =  $this->quitar_tildes2($arr_temp[1]);                   //str_replace("'", "", $arr_temp[1]);
                //$this->objParam->addParametro('descripcion', $text);
                $this->objParam->addParametro('codigo', $arr_temp[1]);
                $this->objParam->addParametro('importe', $arr_temp[2]);
                $this->objFunc = $this->create('MODDeclaracionesJuridicas');
                $this->res = $this->objFunc->insertarDeclaracionesJuridicas($this->objParam); // cambiar
                if ($this->res->getTipo() == 'ERROR') {
                    $error = 'error';
                    $mensaje_completo .= $this->res->getMensaje() . " \n";
                }
            }
        }
        //armar respuesta en caso de exito o error en algunas tuplas
        if ($error == 'error') {
            $this->mensajeRes = new Mensaje();
            $this->mensajeRes->setMensaje('ERROR', 'ACTDeclaracionesJuridicas.php', 'Ocurrieron los siguientes errores : ' . $mensaje_completo,
                $mensaje_completo, 'control');
        } else if ($error == 'no') {
            $this->mensajeRes = new Mensaje();
            $this->mensajeRes->setMensaje('EXITO', 'ACTDeclaracionesJuridicas.php', 'El archivo fue ejecutado con éxito',
                'El archivo fue ejecutado con éxito', 'control');
        }

        if ($error == 'error_fatal') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('ERROR','ACTDeclaracionesJuridicas.php',$mensaje_completo,
                $mensaje_completo,'control');

        }
        if ($error == 'error') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('ERROR','ACTDeclaracionesJuridicas.php','Ocurrieron los siguiente: ' . $mensaje_completo,
                $mensaje_completo,'control');
        } else if ($error == 'no') {
            $this->mensajeRes=new Mensaje();
            $this->mensajeRes->setMensaje('EXITO','ACTDeclaracionesJuridicas.php','El archivo fue ejecutado con éxito',
                'El archivo fue ejecutado con éxito','control');
        }
        //devolver respuesta
        $this->mensajeRes->imprimirRespuesta($this->mensajeRes->generarJson());

    }
    function eliminarFormulario(){
        $this->objFunc=$this->create('MODDeclaracionesJuridicas');
        $this->res=$this->objFunc->eliminarFormulario($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function validarFormulario(){
        $this->objFunc=$this->create('MODDeclaracionesJuridicas');
        $this->res=$this->objFunc->validarFormulario($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }

    function quitar_tildes2($cadena) {
        $no_permitidas= array ("á","é","í","ó","ú","Á","É","Í","Ó","Ú","ñ","À","Ã","Ì","Ò","Ù","Ã™","Ã ","Ã¨","Ã¬","Ã²","Ã¹","ç","Ç","Ã¢","ê","Ã®","Ã´","Ã»","Ã‚","ÃŠ","ÃŽ","Ã”","Ã›","ü","Ã¶","Ã–","Ã¯","Ã¤","«","Ò","Ã","Ã„","Ã‹");
        $permitidas= array ("a","e","i","o","u","A","E","I","O","U","n","N","A","E","I","O","U","a","e","i","o","u","c","C","a","e","i","o","u","A","E","I","O","U","u","o","O","i","a","e","U","I","A","E");
        $texto = str_replace($no_permitidas, $permitidas ,$cadena);
        return $texto;
    }
    function listarDeclaracionesCodigo(){
        $this->objParam->defecto('ordenacion','id_declaracion_juridica');
        $this->objParam->defecto('dir_ordenacion','asc');
        //var_dump($this->objParam->getParametro('filtro'));exit;
        if($this->objParam->getParametro('filtro') != ''){
            $this->objParam->addFiltro("cd.".$this->objParam->getParametro('filtro')." = ''si''");
        }
        $this->objFunc=$this->create('MODDeclaracionesJuridicas');
        $this->res=$this->objFunc->listarDeclaracionesCodigo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
}

?>