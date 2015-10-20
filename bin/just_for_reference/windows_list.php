#!/usr/bin/php -q

<?php

function _get($k,$a) {
	return $a[$k];
}

#elenco finestre aperte su tutti i monitor ordinato sulla coordinata X
exec("wmctrl -l -x -G | sort -n -k 3",$list);

#elenco monitor ordinato sulla coordinata X
exec('xwininfo -root -tree | grep "Enlightenment Black Zone" | grep -v grep | sort -n -k 9 | cut -d " " -f 14',$elenco_monitor);

$numero_monitor=sizeof($elenco_monitor);

$lista="";

$monitor=1; $prev=0;
foreach ($list as $finestra) {

	if(!$offset) $offset=strlen($info[7]);

	$finestra=preg_replace('#\s+#',' ',$finestra);
	$info=explode(' ',$finestra);

	//dati monitor
	if($monitor != $prev) {
		$lista.="Monitor $monitor\n";
		$dati_monitor=explode('+',$elenco_monitor[$monitor]);
		$prev=$monitor;
	}

	$lista.="$info[6] -".substr($finestra,(strpos($finestra,$info[7])+$offset))."\n";

	if ($info[2] > $dati_monitor[1] && $monitor<$numero_monitor) $monitor++;

}

echo $lista;

