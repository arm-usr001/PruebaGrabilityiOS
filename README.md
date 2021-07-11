# PruebaGrabilityiOS_TheMovieDB

Proyecto test para iOS consumiento la API de [TMDb](https://www.themoviedb.org/) usando la arquitectura VIPER, funciones : 
* Consulta por categorias:  Popular, Top-rated, Upcoming
* Visualizar detalle y video de cada audiovisual
* Funcionamiento online y offline (cache)
* Buscador online y offline por categorias
* Unit test para prueba de peticiones de red a la API de [TMDb](https://www.themoviedb.org/)

## Capas de aplicación y tipos asociados 

El proyecto esta implementado siguiendo la arquitectura VIPER, definiendo las siguientes capas:
* **View:**  Capa que dibuja en pantalla lo que se reciba del Presenter. Protocol: AnyView, Clases: ViewController, MovieDetailViewController, MovieTrailerViewController 
* **Interactor:** Capa que contiene la lógica de negocio. Protocol: AnyInteractor, Clase: Interactor.
* **Presenter:** Lógica que la vista tiene que presentar y reacción de los inputs recibidos desde la View. Protocol: AnyPresenter, Clase: Presenter.
* **Entity:** Modelos de los objetos usados por el Interactor. Structs: ResultMovieCall, ResultMovieItemCall, ResultVideoCall, ResultVideoItemCall.
* **Routing:** NAvegación y enlace para presentación de una nueva View. Protocol: AnyRouter, Clase: Router.

## Responsabilidades de otras clases:
* **ArrowView:** Dibuja una UIView con forma de flecha para funcionar como botón animado "Play video"
* **CircularProgressBar:** Dibuja una "barra de progreso" circular, para mostrar el rating animado de cada audiovisual.
* **UtilView:** Permite mostrar un mensaje de alerta.
* **APIURL:** Metodos para formar las URL que se consultaran.
* **APIConstants:** Constantes, llaves, y nombres de metodos de la API de [TMDb](https://www.themoviedb.org/)
* **NetworkMonitor:** Monitorea la conexión a internet.
* **CommonDateUtils:** extensiones para permitir la decodificación correcta de Fechas desde JSON.
* **PruebaGrabilityiOS_TheMovieDBTests:** Unit test para prueba de peticiones de red a la API de [TMDb](https://www.themoviedb.org/)


## Coceptos asociados:

* En qué consiste el principio de responsabilidad única? Cuál es su propósito?

El principio de responsabilidad única dice que cada objeto debe estar encargado de realizar una sola cosa. Su proposito es separar la implementación del codigo para que sea facíl de mantener e identificar donde se debe cambiar cierta resposabilidad.

* Qué características tiene, según su opinión, un “buen” código o código limpio

El código limpio es aquel que está implementado con una estructura sencilla para un fácil seguimiento de su lógica, con una correcta separación de responsabilidades, preparado para reemplazar cada parte especifica sin afectar a otros componentes lo que tambíen permite que esté preparado para pruebas unitarias.



