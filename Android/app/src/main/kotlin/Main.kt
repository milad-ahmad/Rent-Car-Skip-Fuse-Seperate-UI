package complex.skip.app

import android.app.Application
import android.graphics.Color as AndroidColor
import android.os.Bundle
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.SystemBarStyle
import androidx.activity.ComponentActivity
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.luminance
import androidx.compose.ui.platform.LocalContext
import androidx.compose.material3.*
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import androidx.navigation.compose.*
import skip.foundation.*
import skip.ui.*
import complex.skip.app.ui.screens.*
import complex.skip.app.Theme.LuxuryWheelsTheme
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Map
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.Person
internal val logger: SkipLogger = SkipLogger(subsystem = "complex.skip.app", category = "ComplexSkipApp")

private typealias AppDelegate = ComplexSkipAppAppDelegate

open class AndroidAppMain: Application() {
    override fun onCreate() {
        super.onCreate()
        logger.info("starting app")
        ProcessInfo.launch(applicationContext)
        AppDelegate.shared.onLaunch()
    }
}

open class MainActivity: AppCompatActivity() {
    private lateinit var rentalViewModel: RentalViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        logger.info("starting activity")
        UIApplication.launch(this)
        enableEdgeToEdge()

        rentalViewModel = RentalViewModel()

        setContent {
            CompositionLocalProvider(LocalRentalViewModel provides rentalViewModel) {
                CustomNavigationRoot()
            }
        }

        AppDelegate.shared.onLaunch()
    }

    override fun onStart() {
        logger.info("onStart")
        super.onStart()
    }

    override fun onResume() {
        super.onResume()
        AppDelegate.shared.onResume()
    }

    override fun onPause() {
        super.onPause()
        AppDelegate.shared.onPause()
    }

    override fun onStop() {
        super.onStop()
        AppDelegate.shared.onStop()
    }

    override fun onDestroy() {
        super.onDestroy()
        AppDelegate.shared.onDestroy()
    }

    override fun onLowMemory() {
        super.onLowMemory()
        AppDelegate.shared.onLowMemory()
    }

    override fun onRestart() {
        logger.info("onRestart")
        super.onRestart()
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
    }

    override fun onRestoreInstanceState(bundle: Bundle) {
        logger.info("onRestoreInstanceState")
        super.onRestoreInstanceState(bundle)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        logger.info("onRequestPermissionsResult: $requestCode")
    }
}

// CompositionLocal to provide the Swift ViewModel to composables
val LocalRentalViewModel = staticCompositionLocalOf<RentalViewModel> {
    error("No RentalViewModel provided")
}

@Composable
internal fun SyncSystemBarsWithTheme() {
    val dark = MaterialTheme.colorScheme.background.luminance() < 0.5f
    val transparent = AndroidColor.TRANSPARENT
    val style = if (dark) SystemBarStyle.dark(transparent) else SystemBarStyle.light(transparent, transparent)
    val activity = LocalContext.current as? ComponentActivity
    DisposableEffect(style) {
        activity?.enableEdgeToEdge(statusBarStyle = style, navigationBarStyle = style)
        onDispose { }
    }
}

@Composable
internal fun CustomNavigationRoot() {
    val viewModel = LocalRentalViewModel.current
    val navController = rememberNavController()

    LuxuryWheelsTheme {
        SyncSystemBarsWithTheme()
        Scaffold(
            bottomBar = { BottomNavigationBar(navController) }
        ) { paddingValues ->
            NavHost(
                navController = navController,
                startDestination = "explore",
                modifier = Modifier.padding(paddingValues)
            ) {
                composable("explore") {
                    ExploreScreen(viewModel = viewModel, navController = navController)
                }
                composable("map") {
                    MapScreen(viewModel = viewModel, navController = navController)
                }
                composable("rentals") {
                    RentalsScreen(viewModel = viewModel, navController = navController)
                }
                composable("profile") {
                    ProfileScreen(viewModel = viewModel)
                }
                composable("carDetail/{carId}") { backStackEntry ->
                    val carId = backStackEntry.arguments?.getString("carId")
                    CarDetailScreen(viewModel = viewModel, navController = navController, carId = carId)
                }
                composable("booking/{carId}") { backStackEntry ->
                    val carId = backStackEntry.arguments?.getString("carId")
                    BookingScreen(viewModel = viewModel, navController = navController, carId = carId)
                }
            }
        }
    }
}

@Composable
fun BottomNavigationBar(navController: NavHostController) {
    NavigationBar(
        containerColor = MaterialTheme.colorScheme.surface,
        tonalElevation = 0.dp
    ) {
        val items = listOf(
            "explore" to "Explore",
            "map" to "Map",
            "rentals" to "Rentals",
            "profile" to "Profile"
        )
        val currentRoute = currentRoute(navController)
        items.forEach { (route, title) ->
            NavigationBarItem(
                icon = {
                    Icon(
                        imageVector = when (route) {
                            "explore" -> Icons.Default.Search
                            "map" -> Icons.Default.Map
                            "rentals" -> Icons.Default.DateRange
                            else -> Icons.Default.Person
                        },
                        contentDescription = title
                    )
                },
                label = { Text(title) },
                selected = currentRoute == route,
                onClick = {
                    navController.navigate(route) {
                        popUpTo(navController.graph.startDestinationId)
                        launchSingleTop = true
                    }
                }
            )
        }
    }
}

@Composable
fun currentRoute(navController: NavHostController): String? {
    val currentBackStackEntry = navController.currentBackStackEntryAsState().value
    return currentBackStackEntry?.destination?.route
}

@Composable
fun getLocalImageId(imageName: String?): Int? {
    if (imageName.isNullOrEmpty()) return null
    val context = LocalContext.current
    val resId = context.resources.getIdentifier(imageName, "drawable", context.packageName)
    return if (resId == 0) null else resId
}