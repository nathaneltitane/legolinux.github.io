#!/bin/bash

# models pages #

# variables #

extensions_list=(
	png
)

# check if file exists

if [ -f "models/models-menu.html" ]
then
	rm "models/models-menu.html"
fi

# generate models menu

# OPEN MODELS MENU HTML

# ---------------------------------------------------------------------------- #

# generate models menu header

cat << 'FILE' > "models/models-menu.html"


		<script>
		$(function(){
			$.get("/modules/anchors.html", function (data) {$("anchors").append(data);});
			}
		);
		</script>

        <section>

FILE

for extension in ${extensions_list[@]}
do
	count=1

	for models_directory in $(find models/ -type f -iname flat.$extension | shuf)
	do
		IFS='/' read -r -a path <<< $(echo "$models_directory")

		# /models/model-type/model/renders/flat/flat.$extension

		# echo "${path[0]}" # /models
		# echo "${path[1]}" # /model-type
		# echo "${path[2]}" # /model
		# echo "${path[3]}" # /renders
		# echo "${path[4]}" # /outine
		# echo "${path[5]}" # /flat file

		model_string="$(echo ${path[2]%} | sed 's/\(.*\)-/\1 /')"

		IFS=' ' read -r model_id_string model_name_string <<< "${model_string}"

		model_id=${model_id_string^^}
		model_name=${model_name_string^^}
		model_title=${model_string^^}

		flat_file="${path[5]}"
		flat_file_name="${path[5]%.*}"

		# generate model type directory title header

		if [ $count -eq 1 ]
		then
			hidden=""
		else
			hidden="hidden"
		fi

cat << MODEL-TYPE >> "models/models-menu.html"
            <div class='container $hidden' id=${model_string^^}>

				<div class='grid grid-gutters grid-full large-grid-fit'>
					<div class='grid-cell'>
						<div class="button title" id="title">
								${model_title}
						</div>
					</div>
				</div>

MODEL-TYPE

# generate model menu entry

cat << MODEL >> "models/models-menu.html"
				<div class='grid-cell'>
					<a class='load-model' href="models/${path[1]}/${path[2]}" target='_blank'>
						<img src="/${path[0]}/${path[1]}/${path[2]}/${path[3]}/${path[4]}/${path[5]}" />
					</a>
				</div>
			</div>

MODEL

# OPEN MODEL HTML

# ---------------------------------------------------------------------------- #

# generate model index

cat > "models/${path[1]}/${path[2]}/index.html" << INDEX
<!DOCTYPE html>

<html>
	<head>

		<!-- css -->

		<link rel="stylesheet" href="/css/style.css" type="text/css" />

		<!-- libraries -->

		<script src="/javascript/jquery-3.4.1.min.js" type="text/javascript"></script>

		<!-- scripts -->

		<script src="/javascript/load-modules.js" type="text/javascript"></script>

	</head>

	<body>

		<section>

			<!-- model title -->

			<div class="grid grid-gutters grid-full large-grid-fit">
				<div class="grid-cell">
					<div class="button title" id="title">

					</div>
				</div>
			</div>

		</section>

		<!-- model render container -->

		<section>

			<div class="grid grid-gutters grid-full large-grid-fit">
				<div class="grid-cell">
					<canvas id="model-canvas">

					</canvas>
				</div>
			</div>

		</section>

		<!-- model render -->

		<script type="module">

			import * as THREE from '/build/three.module.js';

			import Stats from '/jsm/libs/stats.module.js';

			import { ColladaLoader } from '/jsm/loaders/ColladaLoader.js';
			import { OrbitControls } from '/jsm/controls/OrbitControls.js';

			var canvas, renderer, controls, camera, scene;

			function init() {

				canvas = document.querySelector('#model-canvas');

				// renderer

				renderer = new THREE.WebGLRenderer( { canvas, antialias: true, alpha: true } );
				renderer.setClearColor( 0x000000, 0 );
				renderer.shadowMap.enabled = true;
				renderer.shadowMap.type = THREE.PCFSoftShadowMap;
				renderer.setPixelRatio( window.devicePixelRatio );

				// camera

				const camera = new THREE.PerspectiveCamera(45, 2, 0.1, 5);
				camera.position.z = 2;
				// camera.position.set( 45, 0, 45 );

				// scene

				scene = new THREE.Scene();

				// controls

				controls = new OrbitControls( camera, renderer.domElement );
				controls.screenSpacePanning = true;
				controls.minDistance = 0.25;
				controls.maxDistance = 0.65;
				controls.target.set( 0, 0, 0 );
				controls.update();

				// lights

				var ambientLight = new THREE.AmbientLight( 0xffffff, 0.75 );
				scene.add( ambientLight );

				// var hemiLight = new THREE.HemisphereLight( 0xffffff, 0xffffff, 1 );
				// hemiLight.castShadow = true;
				// scene.add( hemiLight );

				// var dirLight = new THREE.DirectionalLight( 0xffffff, 1, 100 );
				// dirLight.position.set( 0, 1, 0 );					//default
				// dirLight.castShadow = true;

				// dirLight.shadow.mapSize.width = 512;					// default
				// dirLight.shadow.mapSize.height = 512;				// default
				// dirLight.shadow.camera.near = 0.5;					// default
				// dirLight.shadow.camera.far = 500;					// default
				// scene.add( dirLight );

				var pointLight = new THREE.PointLight( 0xffffff, 0.15 );
				pointLight.castShadow = true;
				pointLight.shadow.mapSize.width = 512;				// default
				pointLight.shadow.mapSize.height = 512;				// default
				pointLight.shadow.camera.near = 0.5;				// default
				pointLight.shadow.camera.far = 500;					// default

				scene.add( camera );
				camera.add( pointLight );

				// loader

				// collada

				var loader = new ColladaLoader();
				loader.load( '/${path[0]}/${path[1]}/${path[2]}/exports/${path[2]}.dae', function ( collada ) {

					var boundingbox = new THREE.Box3()
					var model = collada.scene;						// model as group

					model.traverse( function ( node ) {

						if ( node.isSkinnedMesh ) {

							node.frustumCulled = false;

						}

					} );

					model.traverse( function ( child ) {

						// make model group children shadow responsive

						child.castShadow = true;
						child.receiveShadow = true;

						console.log(child);

					} );

					// load model

					scene.add( model );

					// set bounding box

					boundingbox.setFromObject(model);
					boundingbox.center(controls.target);

				} );

				// stats

				// var stats = new Stats();
				// container.appendChild( stats.dom );

				// helpers

				// grid

				// var gridHelper = new THREE.GridHelper( 1, 1 );
				// scene.add( gridHelper );

				// bounding box

				// var box = new THREE.BoxHelper( object, 0x000000 );
				// scene.add( box );

				//

				function resize () {

					const canvas = renderer.domElement;

					const width = canvas.clientWidth;			// get parent width
					// const height = canvas.clientHeight;		// default
					const height = canvas.clientWidth;			// force 1:1 canvas ratio

					const resizeNeeded = canvas.width !== width || canvas.height !== height;

					if ( resizeNeeded ) {
						renderer.setSize ( width, height, false );
					}
					return resizeNeeded;
				}

				function render() {

					if ( resize ( renderer ) ) {

						const canvas = renderer.domElement;
						camera.aspect = canvas.clientWidth / canvas.clientHeight;
						camera.updateProjectionMatrix();

					}


					renderer.render( scene, camera );
					requestAnimationFrame( render );
				}

				requestAnimationFrame( render );

			}

			init();
		</script>

		<section>

		<!-- ldraw model view -->

			<div class='container' id='${model_string^^}'>

			<!-- renders -->

			<section>
				<div class="grid grid-gutters grid-full large-grid-fit">
					<div class="grid-cell">
						<div class="button title" id="title">
							Renders // Model Views
						</div>
					</div>
				</div>
			</section>

			<div class='grid grid-gutters grid-full display-grid-fit'>

				<!-- quarter front view -->

				<div class='grid-cell'>
					<a href='./${path[3]}/${path[2]}-quarter-front.$extension' target='_blank'>
						<img src='./${path[3]}/${path[2]}-quarter-front.$extension'/>
					</a>
				</div>

				<!-- front view -->

				<div class='grid-cell'>
					<a href='./${path[3]}/${path[2]}-front.$extension' target='_blank'>
						<img src='./${path[3]}/${path[2]}-front.$extension'/>
					</a>
				</div>

				<!-- quarter back view -->

				<div class='grid-cell'>
					<a href='./${path[3]}/${path[2]}-quarter-back.$extension' target='_blank'>
						<img src='./${path[3]}/${path[2]}-quarter-back.$extension'/>
					</a>
				</div>

				<!-- back view -->

				<div class='grid-cell'>
					<a href='./${path[3]}/${path[2]}-back.$extension' target='_blank'>
						<img src='./${path[3]}/${path[2]}-back.$extension'/>
					</a>
				</div>

			</div>

		</section>

		<section id="footer">
			<footer>

			</footer>
		</section>

	</body>
</html>
INDEX

# ---------------------------------------------------------------------------- #

# CLOSE MODEL HTML

		((count++))

	done
done

# generate models menu footer

cat << FILE >> "models/models-menu.html"
        </section>

		<section id="anchors">
			<anchors>

			</anchors>
		</section>

FILE

# ---------------------------------------------------------------------------- #

# CLOSE MODELS MENU HTML