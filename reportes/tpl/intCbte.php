<?php  
  $cabecera = $dataSource->getParameter('cabecera');
  $detalleCbte = $dataSource->getParameter('detalleCbte');
?>
<html>
	 <head></head>
<body>
	
	<table width="100%" style="width: 100%; text-align: center;" cellspacing="0" cellpadding="1" border="1">
	<tbody><tr>
		<!--<td width="23%" rowspan="4"><img  border="0" src="../imagenes/logos/logo.jpg"></td>-->
		<td style="width: 23%; color: #444444;" rowspan="4">
			<img  style="width: 150px;" src="./../../../lib/imagenes/logos/logo.jpg" alt="Logo">
		</td>		
		<td style="width: 54%; color: #444444;" rowspan="2"><h1><?php  echo $cabecera[0]['beneficiario']; ?> </h1></td>
		<td style="width: 23%; color: #444444;"><b>Depto.:</b> <?php  echo $cabecera[0]['cod_depto']; ?> </td>
	</tr>
	<tr>
		<td style="width: 23%; color: #444444;"><b>N°:</b> <?php  echo $cabecera[0]['nro_cbte']; ?> </td>
	</tr>
	<tr>
		<td style="width: 54%; color: #444444;" rowspan="2"><h2>MOMENTO PRESUPUESTARIO: DEVENGADO</h2><h2></h2></td>
		<td style="width: 23%; color: #444444;"><b>Fecha:</b> <?php  echo $cabecera[0]['fecha']; ?></td>
	</tr>
	<tr>
		<td style="width: 23%; color: #444444;"><b>Moneda</b> <?php  echo $cabecera[0]['desc_moneda']; ?> </td>
	</tr>
</tbody></table>
<br>
<br>

<table width="100%" cellspacing="0" cellpadding="0" border="0">
	
		<tr>
			<td width="50%"><b>Acreedor:</b>  <?php  echo $cabecera[0]['beneficiario']; ?></td>
			<td width="50%"><b>Conformidad:</b> ADQ-OCN-5/3-2015 </td>
		</tr>
		<tr>
			<td><b>Operación:</b> </td>
			<td><b>T/C:</b> <?php  echo $cabecera[0]['tipo_cambio']; ?></td>
		</tr>
		<tr>
			<td></td>
			<td><b>Facturas:</b>  <?php  echo $cabecera[0]['tipo_cambio']; ?></td>
		</tr>
		<tr>
			<td></td>
			<td><b>Pedido:</b> </td>
		</tr>
		<tr>
			<td></td>
			<td><b>Aprobación:</b> </td>
		</tr>
	
</table>
<br>
<br>


<table width="100%" cellspacing="0" cellpadding="0" border="1">
	<tbody>
		<tr>
			<td width="60%" align="center" >DETALLE</td>
			<td width="20%" align="center" class="td_currency"><span>DEBE</span></td>
			<td width="20%" align="center" class="td_currency"><span>HABER</span></td>
		</tr>
		<?php 
		   $tot_debe = 0;
		   $tot_haber = 0;
		   foreach($detalleCbte as $key=>$val){     ?>
		<tr>
		    <td width="60%">
				<b>CC:</b> <?php  echo  $val['cc']; ?> <br/>
				<b>Ptda.:</b> <?php  echo $val['partida']; ?><br/>
	   			<b>Cta.:</b> <?php  echo $val['cuenta']; ?><br/>
	   			<b>Aux.:</b> <?php  echo $val['auxiliar']; ?>
			</td>
			<td width="20%" align="right" class="td_currency"><span><?php  echo  $val['importe_debe']; ?></span></td>
			<td width="20%" align="right" class="td_currency"><span><?php  echo  $val['importe_haber']; ?></span></td>
		</tr>
		<?php  
		    $tot_debe+=$val['importe_debe'];
			$tot_haber+=$val['importe_haber'];
		
		} ?>
		
		<tr>
			<td width="60%" align="right"><b>TOTALES</b></td>		
			<td width="20%" align="right" class="td_currency"><span><b><?php  echo $tot_debe; ?></b></span></td>
			<td width="20%" align="right" class="td_currency"><span><b><?php  echo $tot_haber; ?></b></span></td>
	    </tr>
	
	
</tbody></table>
<br><br>

<table width="100%" cellspacing="0" cellpadding="0" border="1">
	<tbody><tr>
		<td width="25%" class="td_label"><span>Centro Responsable</span></td>
		<td width="25%" class="td_label"><span>Elaborado por</span></td>
		<td width="25%" class="td_label"><span>Beneficiario</span></td>
		<td width="25%" class="td_label"><span>VoBo</span></td>
	</tr>
	<tr>
		<td width="25%" class="td_label"><br><br><br></td>
		<td width="25%" class="td_label"><br><br><br></td>
		<td width="25%" class="td_label"><br><br><br></td>
		<td width="25%" class="td_label"><br><br><br></td>
	</tr>
	<tr>
		<td width="25%" class="td_label"><span></span></td>
		<td width="25%" class="td_label"><span></span></td>
		<td width="25%" class="td_label"><span></span></td>
		<td width="25%" class="td_label"><span></span></td>
	</tr>
	<tr>
		<td width="25%" class="td_label"><span></span></td>
		<td width="25%" class="td_label"><span></span></td>
		<td width="25%" class="td_label"><span></span></td>
		<td width="25%" class="td_label"><span></span></td>
	</tr>
</tbody></table></body></html>