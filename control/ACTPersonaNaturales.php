<?php
/**
*@package pXP
*@file gen-ACTPersonaNaturales.php
*@author  (admin)
*@date 31-05-2017 20:17:08
*@description Clase que recibe los parametros enviados por la vista para mandar a la capa de Modelo
*/

class ACTPersonaNaturales extends ACTbase{    
			
	function listarPersonaNaturales(){
		$this->objParam->defecto('ordenacion','id_persona_natural');
		$this->objParam->defecto('dir_ordenacion','asc');
        if($this->objParam->getParametro('id_periodo') != ''){
            $this->objParam->addFiltro("pns.id_periodo = ".$this->objParam->getParametro('id_periodo'));
        }
        if($this->objParam->getParametro('id_depto')!=''){
            if($this->objParam->getParametro('id_depto')!=0)
                $this->objParam->addFiltro("pns.id_depto_conta = ".$this->objParam->getParametro('id_depto'));
        }
		if($this->objParam->getParametro('tipoReporte')=='excel_grid' || $this->objParam->getParametro('tipoReporte')=='pdf_grid'){
			$this->objReporte = new Reporte($this->objParam,$this);
			$this->res = $this->objReporte->generarReporteListado('MODPersonaNaturales','listarPersonaNaturales');
		} else{
			$this->objFunc=$this->create('MODPersonaNaturales');
			
			$this->res=$this->objFunc->listarPersonaNaturales($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
				
	function insertarPersonaNaturales(){
		$this->objFunc=$this->create('MODPersonaNaturales');	
		if($this->objParam->insertar('id_persona_natural')){
			$this->res=$this->objFunc->insertarPersonaNaturales($this->objParam);			
		} else{			
			$this->res=$this->objFunc->modificarPersonaNaturales($this->objParam);
		}
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
						
	function eliminarPersonaNaturales(){
			$this->objFunc=$this->create('MODPersonaNaturales');	
		$this->res=$this->objFunc->eliminarPersonaNaturales($this->objParam);
		$this->res->imprimirRespuesta($this->res->generarJson());
	}
    function cambiarRevision(){
        $this->objFunc=$this->create('MODPersonaNaturales');
        $this->res=$this->objFunc->cambiarRevision($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());

    }
    function exporta_txt(){
        setlocale(LC_ALL,"es_ES@euro","es_ES","esp");

        $this->objFunc2=$this->create('MODComisionistas');
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
            $this->objParam->addFiltro("pns.id_periodo = ''".$this->objParam->getParametro('id_periodo')."'' ");
            $this->objParam->addFiltro("pns.id_depto_conta = ".$this->objParam->getParametro('id_depto'));
            $mmaaaa = $periodo.$gestion;
        }
        if($this->objParam->getParametro('gestion') != ''){
            $this->objParam->addFiltro("ges.gestion = ''".$gestion."'' and pns.id_depto_conta = ''".$this->objParam->getParametro('id_depto')."'' ");
            $mmaaaa = $gestion;
        }
        $this->objParam->addFiltro("pns.revisado = ''si'' ");
        $nit_empresa = $this->nitEmpresa();
        $this->objFunc=$this->create('MODPersonaNaturales');
        $this->res=$this->objFunc->listarPersonaNaturales($this->objParam);
        $datos = $this->res->getDatos();
        $MiDocumento = fopen("../../../reportes_generados/"."PERSONASNATURALES_".$mmaaaa.'_'.$nit_empresa.".txt", "w+");
        $nombre_archivo = "PERSONASNATURALES_".$mmaaaa.'_'.$nit_empresa;

        foreach ($datos as $dato) {
            $Escribo = "".  $dato['codigo_cliente'] ."|"
                .$dato['tipo_documento']."|"
                .$dato['nro_documeneto'] ."|"
                .$dato['nombre'] ."|"
                .$dato['codigo_producto'] ."|"
                .$dato['descripcion']."|"
                .$dato['cantidad_producto'] ."|"
                .$dato['precio_unitario']."|"
                .$dato['importe_total']."|";

            fwrite($MiDocumento, $Escribo);
            fwrite($MiDocumento, chr(13).chr(10)); //genera el salto de linea
        }
        fclose($MiDocumento);

        $this->res->setDatos($nombre_archivo);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function  nitEmpresa(){
        $this->objFunc2=$this->create('MODPersonaNaturales');
        $this->res2=$this->objFunc2->nitEmpresa($this->objParam);
        $empresa = $this->res2;
        $nit_empresa = $empresa[0]['nit'];
        return $nit_empresa;
    }
    function importar_txt (){
        $this->objFunc=$this->create('MODPersonaNaturales');
        $this->res=$this->objFunc->importar_txt($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function BorrarTodo(){
        $this->objFunc=$this->create('MODPersonaNaturales');
        $this->res=$this->objFunc->BorrarTodo($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function clonar(){
        $this->objFunc=$this->create('MODPersonaNaturales');
        $this->res=$this->objFunc->clonar($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
    function agregarListarNegra(){
        $this->objFunc=$this->create('MODPersonaNaturales');
        $this->res=$this->objFunc->agregarListarNegra($this->objParam);
        $this->res->imprimirRespuesta($this->res->generarJson());
    }
			
}

?>