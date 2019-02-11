<?php
/**
*@package pXP
*@file gen-ACTAnexosActualizaciones.php
*@author  (miguel.mamani)
*@date 27-06-2017 13:39:16
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTAnexosActualizaciones extends ACTbase{    
			
	function listarAnexosActualizaciones(){
		$this->objParam->defecto('ordenacion','id_anexos_actualizaciones');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_periodo') != ''){
            $this->objParam->addFiltro("ans.id_periodo = ".$this->objParam->getParametro('id_periodo'));
        }
        if($this->objParam->getParametro('id_depto')!=''){
            if($this->objParam->getParametro('id_depto')!=0)
                $this->objParam->addFiltro("ans.id_depto_conta = ".$this->objParam->getParametro('id_depto'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODAnexosActualizaciones','listarAnexosActualizaciones');
		} else{
			$this->objFunc=$this->create('MODAnexosActualizaciones');
			
			$this->res=$this->objFunc->listarAnexosActualizaciones($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarAnexosActualizaciones(){
		$this->objFunc=$this->create('MODAnexosActualizaciones');	
		if($this->objParam->insertar('id_anexos_actualizaciones')){
			$this->res=$this->objFunc->insertarAnexosActualizaciones($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarAnexosActualizaciones($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarAnexosActualizaciones(){
			$this->objFunc=$this->create('MODAnexosActualizaciones');	
		$this->res=$this->objFunc->eliminarAnexosActualizaciones($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function cambiarRevision(){
        $this->objFunc=$this->create('MODAnexosActualizaciones');
        $this->res=$this->objFunc->cambiarRevision($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());

    }
    function exporta_txt(){
        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");
        $this->objFunc2=$this->create('MODAnexosActualizaciones');
        $this->res2=$this->objFunc2->listarPeriodoGestion($this->objParam);
        $periodo_gestion = $this->res2;
        $periodo = $periodo_gestion[0]['periodo'];
        $gestion = $periodo_gestion[0]['gestion'];
        if($periodo < 10){
            $periodo = "0".$periodo;
        }

        $this->objParam->defecto('ordenacion','id_periodo');
        $this->objParam->defecto('dir_ordenacion','asc');

        if($this->objParam->getParametro('id_periodo') != '' &&  $this->objParam->getParametro('gestion') == ''){
            $this->objParam->addFiltro("ans.id_periodo = ''".$this->objParam->getParametro('id_periodo')."'' ");
            $this->objParam->addFiltro("ans.id_depto_conta = ".$this->objParam->getParametro('id_depto'));
            $mmaaaa = $periodo.$gestion;
        }
       // var_dump($this->objParam->getParametro('id_depto')); exit;
        if($this->objParam->getParametro('gestion') != ''){

            $this->objParam->addFiltro("ge.gestion = ''".$gestion."'' and ans.id_depto_conta = ''".$this->objParam->getParametro('id_depto')."'' ");
            $mmaaaa = $gestion;
        }
        $this->objParam->addFiltro("ans.revisado = ''si''");
        $nit_empresa = $this->nitEmpresa();
        $this->objFunc=$this->create('MODAnexosActualizaciones');
        $this->res=$this->objFunc->listarAnexosActualizaciones($this->objParam);
        $datos = $this->res->getDatos();
        $MiDocumento = fopen("../../../reportes_generados/"."ACT_ANEXOS_".$mmaaaa.'_'.$nit_empresa.".txt", "w+");
        $nombre_archivo = "ACT_ANEXOS_".$mmaaaa.'_'.$nit_empresa;
        foreach ($datos as $dato) {

            if ($dato['tipo_comision'] == 'PORCENTUAL'){
                $monto = $dato['monto_porcentaje'].'%';
            }else{
                $monto = $dato['monto_porcentaje'];
            }
            $Escribo = ""   .$dato['nit_proveerdor'] ."|"
                            .$dato['nro_contrato']."|"
                            .$dato['nit_comisionista'] ."|"
                            .strftime("%d/%m/%Y", strtotime($dato['fecha_vigente']))  ."|"
                            .$dato['codigo_producto'] ."|"
                            .$dato['descripcion_producto']."|"
                            .$dato['precio_unitario'] ."|"
                            .$dato['tipo_comision']."|"
                            .$monto."|";

            fwrite($MiDocumento, $Escribo);
            fwrite($MiDocumento, chr(13).chr(10)); //genera el salto de linea
        }
        fclose($MiDocumento);

        $this->res->setDatos($nombre_archivo);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function  nitEmpresa(){
        $this->objFunc2=$this->create('MODAnexosActualizaciones');
        $this->res2=$this->objFunc2->nitEmpresa($this->objParam);
        $empresa = $this->res2;
        $nit_empresa = $empresa[0]['nit'];
        return $nit_empresa;
    }
    function importar_txt (){
        $this->objFunc=$this->create('MODAnexosActualizaciones');
        $this->res=$this->objFunc->importar_txt($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function BorrarTodo(){
        $this->objFunc=$this->create('MODAnexosActualizaciones');
        $this->res=$this->objFunc->BorrarTodo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function clonar(){
        $this->objFunc=$this->create('MODAnexosActualizaciones');
        $this->res=$this->objFunc->clonar($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function agregarListarNegra(){
        $this->objFunc=$this->create('MODAnexosActualizaciones');
        $this->res=$this->objFunc->agregarListarNegra($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>