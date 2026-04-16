package complex.skip.app.ui.screens

import androidx.compose.foundation.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import coil.compose.AsyncImage
import kotlinx.coroutines.delay
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.List
import androidx.compose.material.icons.filled.LocationOn
import complex.skip.app.Car
import complex.skip.app.RentalViewModel
import complex.skip.app.Theme.LuxuryGold
import complex.skip.app.Theme.SurfacePrimary
import complex.skip.app.Theme.SurfaceSecondary
import complex.skip.app.Theme.TextPrimary
import complex.skip.app.Theme.TextSecondary
import skip.lib.Array

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ExploreScreen(viewModel: RentalViewModel, navController: NavController) {
    var searchText by remember { mutableStateOf("") }
    var selectedCategory by remember { mutableStateOf("All") }
    val categories = listOf("All", "Sports", "Luxury", "SUV", "Electric", "Convertible")
    val featuredCars by remember { derivedStateOf { viewModel.featuredCars } }
    val nearbyCars by remember { derivedStateOf { viewModel.nearbyCars } }

    Scaffold(
        topBar = {
            TopAppBar(
                title = {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(modifier = Modifier.size(32.dp).clip(RoundedCornerShape(8.dp)).background(SurfaceSecondary))
                        Spacer(modifier = Modifier.width(8.dp))
                        Column {
                            Text("LUXURY WHEELS", style = MaterialTheme.typography.titleMedium, color = LuxuryGold)
                            Text("Premium Car Rental", style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                        }
                    }
                },
                actions = {
                    IconButton(onClick = {}) {
                        Icon(imageVector = Icons.Default.Notifications, contentDescription = null)
                    }
                    IconButton(onClick = { navController.navigate("profile") }) {
//                        AsyncImage(
//                            model = viewModel.currentUser?.profileImage,
//                            contentDescription = null,
//                            modifier = Modifier.size(36.dp).clip(CircleShape)
//                        )
                        AppImage (
                            source = viewModel.currentUser?.profileImage,
                            modifier = Modifier.size(36.dp).clip(CircleShape)
                        )
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(containerColor = Color.Transparent)
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier.fillMaxSize().padding(padding),
            contentPadding = PaddingValues(bottom = 16.dp)
        ) {
            item { HeroCarousel(cars = featuredCars, navController = navController) }
            item { SearchBar(searchText = searchText, onSearchChange = { searchText = it }) }
            item { CategoryRow(categories = categories, selected = selectedCategory, onSelect = { selectedCategory = it }) }
            item { SectionHeader(title = "Featured Vehicles") }

            item {
                LazyRow(
                    horizontalArrangement = Arrangement.spacedBy(16.dp),
                    contentPadding = PaddingValues(horizontal = 16.dp)
                ) {
                    items(featuredCars.toList(), key = { it.id.toString() }) { car ->
                        FeaturedCarCard(car = car, onClick = { navController.navigate("carDetail/${car.id}") })
                    }
                }
            }
            item { SectionHeader(title = "Popular Near You") }

            // VOEG .toString() TOE AAN DE KEY
            items(nearbyCars.toList(), key = { it.id.toString() }) { car ->
                CarListItem(car = car, onClick = { navController.navigate("carDetail/${car.id}") })
            }
        }
    }
}

@Composable
fun HeroCarousel(cars: Array<Car>, navController: NavController) {
    var currentIndex by remember { mutableIntStateOf(0) }
    LaunchedEffect(Unit) {
        while (true) {
            delay(5000)
            currentIndex = (currentIndex + 1) % cars.count
        }
    }
    Box(modifier = Modifier.height(500.dp).fillMaxWidth()) {
        if (cars.count > 0) {
            HeroCarCard(car = cars[currentIndex], navController = navController)
            Row(
                modifier = Modifier.align(Alignment.BottomCenter).padding(bottom = 16.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                repeat(cars.count) { index ->
                    Box(
                        modifier = Modifier.size(8.dp).clip(CircleShape)
                            .background(if (index == currentIndex) LuxuryGold else Color.White.copy(alpha = 0.5f))
                    )
                }
            }
        }
    }
}

@Composable
fun HeroCarCard(car: Car, navController: NavController) {
    Box(modifier = Modifier.fillMaxSize()) {
//        AsyncImage(
//            model = car.images.firstOrNull(),
//            contentDescription = null,
//            modifier = Modifier.fillMaxSize(),
//            contentScale = ContentScale.Crop
//        )
        AppImage(
            source = car.images.firstOrNull(),
            modifier = Modifier.fillMaxSize(),
            contentScale = ContentScale.Crop
        )
        Box(
            modifier = Modifier.fillMaxSize().background(
                Brush.verticalGradient(
                    colors = listOf(Color.Black.copy(alpha = 0.6f), Color.Transparent, Color.Black.copy(alpha = 0.4f))
                )
            )
        )
        Column(
            modifier = Modifier.align(Alignment.BottomStart).padding(24.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Badge(text = car.availability.name, color = Color.Green)
                Badge(text = "${car.horsepower} HP", color = LuxuryGold)
            }
            Text(car.make, style = MaterialTheme.typography.headlineMedium, color = Color.White)
            Text(car.model, style = MaterialTheme.typography.headlineLarge, color = Color.White, fontWeight = FontWeight.Bold)
            RatingBar(rating = car.rating, size = 12)
            Row(verticalAlignment = Alignment.CenterVertically) {
                Column {
                    Text("From", style = MaterialTheme.typography.labelSmall, color = Color.White.copy(alpha = 0.8f))
                    Text("$${car.pricePerDay.toInt()}/day", style = MaterialTheme.typography.titleLarge, color = LuxuryGold)
                }
                Spacer(modifier = Modifier.weight(1f))
                Button(
                    onClick = { navController.navigate("carDetail/${car.id}") },
                    colors = ButtonDefaults.buttonColors(containerColor = LuxuryGold, contentColor = Color.Black),
                    shape = CircleShape
                ) {
                    Text("Book Now")
                }
            }
        }
    }
}

@Composable
fun Badge(text: String, color: Color) {
    Box(modifier = Modifier.background(color, CircleShape).padding(horizontal = 8.dp, vertical = 4.dp)) {
        Text(text, style = MaterialTheme.typography.labelSmall, color = Color.White)
    }
}

@Composable
fun RatingBar(rating: Double, size: Int) {
    Row(horizontalArrangement = Arrangement.spacedBy(2.dp)) {
        repeat(5) { index ->
            Icon(
                imageVector = Icons.Default.Star,
                contentDescription = null,
                modifier = Modifier.size(size.dp),
                tint = if (index < rating) LuxuryGold else Color.Gray.copy(alpha = 0.3f)
            )
        }
    }
}

@Composable
fun SearchBar(searchText: String, onSearchChange: (String) -> Unit) {
    Surface(
        modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 8.dp),
        shape = RoundedCornerShape(16.dp),
        shadowElevation = 4.dp
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(imageVector = Icons.Default.Search, contentDescription = null, tint = TextSecondary)
            Spacer(modifier = Modifier.width(8.dp))
            TextField(
                value = searchText,
                onValueChange = onSearchChange,
                placeholder = { Text("Search for a car...") },
                modifier = Modifier.weight(1f),
                colors = TextFieldDefaults.colors(
                    focusedContainerColor = Color.Transparent,
                    unfocusedContainerColor = Color.Transparent,
                    focusedIndicatorColor = Color.Transparent,
                    unfocusedIndicatorColor = Color.Transparent
                )
            )
            IconButton(onClick = {}) {
                Icon(imageVector = Icons.Default.List, contentDescription = null, tint = LuxuryGold)
            }
        }
    }
}

@Composable
fun CategoryRow(categories: List<String>, selected: String, onSelect: (String) -> Unit) {
    LazyRow(
        horizontalArrangement = Arrangement.spacedBy(12.dp),
        contentPadding = PaddingValues(horizontal = 16.dp)
    ) {
        items(categories) { category ->
            CategoryPill(category = category, isSelected = selected == category, onClick = { onSelect(category) })
        }
    }
}

@Composable
fun CategoryPill(category: String, isSelected: Boolean, onClick: () -> Unit) {
    Surface(
        onClick = onClick,
        shape = CircleShape,
        color = if (isSelected) LuxuryGold else SurfacePrimary,
        border = if (!isSelected) BorderStroke(1.dp, LuxuryGold.copy(alpha = 0.3f)) else null
    ) {
        Text(
            category,
            modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp),
            color = if (isSelected) Color.Black else TextPrimary
        )
    }
}

@Composable
fun SectionHeader(title: String) {
    Row(
        modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 12.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(title, style = MaterialTheme.typography.titleLarge, color = TextPrimary)
        TextButton(onClick = {}) { Text("See All", color = LuxuryGold) }
    }
}

@Composable
fun FeaturedCarCard(car: Car, onClick: () -> Unit) {
    Card(
        modifier = Modifier.width(280.dp).clickable { onClick() },
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
    ) {
        Column {
//            AsyncImage(
//                model = car.images.firstOrNull(),
//                contentDescription = null,
//                modifier = Modifier.height(180.dp).fillMaxWidth(),
//                contentScale = ContentScale.Crop
//            )
            AppImage(
                source = car.images.firstOrNull(),
                modifier = Modifier.height(180.dp).fillMaxWidth(),
                contentScale = ContentScale.Crop
            )
            Column(modifier = Modifier.padding(8.dp)) {
                Text(car.make, style = MaterialTheme.typography.titleMedium)
                Text(car.model, style = MaterialTheme.typography.titleLarge, color = LuxuryGold, fontWeight = FontWeight.Bold)
                Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                    RatingBar(rating = car.rating, size = 12)
                    Text("$${car.pricePerDay.toInt()}/day", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.SemiBold)
                }
            }
        }
    }
}

@Composable
fun CarListItem(car: Car, onClick: () -> Unit) {
    Card(
        modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp, vertical = 8.dp).clickable { onClick() },
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
    ) {
        Row(modifier = Modifier.padding(16.dp), verticalAlignment = Alignment.CenterVertically) {
//            AsyncImage(
//                model = car.images.firstOrNull(),
//                contentDescription = null,
//                modifier = Modifier.size(100.dp, 80.dp).clip(RoundedCornerShape(12.dp)),
//                contentScale = ContentScale.Crop
//            )
            AppImage(
                source = car.images.firstOrNull(),
                modifier = Modifier.size(100.dp, 80.dp)
            )
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                Row {
                    Text("${car.year} ${car.make} ${car.model}", style = MaterialTheme.typography.titleMedium, maxLines = 1)
                    Spacer(modifier = Modifier.weight(1f))
                    Badge(text = car.availability.name, color = if (car.availability == Car.AvailabilityStatus.available) Color.Green else Color.Yellow)
                }
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(imageVector = Icons.Default.LocationOn, contentDescription = null, modifier = Modifier.size(12.dp), tint = TextSecondary)
                    Text(car.location.city, style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                }
                Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                    RatingBar(rating = car.rating, size = 12)
                    Column(horizontalAlignment = Alignment.End) {
                        Text("$${car.pricePerDay.toInt()}/day", style = MaterialTheme.typography.titleMedium, color = LuxuryGold)
                        Text("$${car.pricePerWeek.toInt()}/week", style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                    }
                }
            }
        }
    }
}

@Composable
fun MembershipBanner(viewModel: RentalViewModel) {
    Card(
        modifier = Modifier.fillMaxWidth().padding(16.dp),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = SurfacePrimary),
        border = BorderStroke(1.dp, LuxuryGold.copy(alpha = 0.3f))
    ) {
        Row(modifier = Modifier.padding(16.dp)) {
            Column(modifier = Modifier.weight(1f)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(imageVector = Icons.Default.Star, contentDescription = null, tint = LuxuryGold)
                }
                Text("You have ${viewModel.currentUser?.rewards?.points ?: 0} points", color = TextPrimary)
                LinearProgressIndicator(
                    progress = { (viewModel.currentUser?.rewards?.points ?: 0).toFloat() / 25000f },
                    modifier = Modifier.fillMaxWidth().height(4.dp),
                    color = LuxuryGold,
                    trackColor = ProgressIndicatorDefaults.linearTrackColor,
                    strokeCap = ProgressIndicatorDefaults.LinearStrokeCap,
                )
            }
            Column(horizontalAlignment = Alignment.End) {
                Text("Next Tier", style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                Text("${viewModel.currentUser?.rewards?.nextTierPoints ?: 25000} pts", color = LuxuryGold, fontWeight = FontWeight.Bold)
            }
        }
    }
}