package complex.skip.app.ui.screens

import androidx.compose.foundation.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import coil.compose.AsyncImage
import coil.request.ImageRequest
import complex.skip.app.Car
import complex.skip.app.CarColor
import complex.skip.app.DealerLocation
import complex.skip.app.InsuranceOption
import complex.skip.app.RentalViewModel
import complex.skip.app.Theme.BackgroundPrimary
import complex.skip.app.Theme.LuxuryGold
import complex.skip.app.Theme.SurfacePrimary
import complex.skip.app.Theme.TextSecondary
import complex.skip.app.Theme.SurfaceSecondary
import kotlin.collections.isNotEmpty
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Star
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Map
import androidx.compose.material.icons.filled.Close

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CarDetailScreen(
    viewModel: RentalViewModel,
    navController: NavController,
    carId: String?
) {
    val car = remember(carId) { viewModel.allCars.find { it.id.toString() == carId } }
    if (car == null) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            CircularProgressIndicator(color = LuxuryGold)
        }
        return
    }

    var selectedColor by remember { mutableStateOf(car.colorOptions.firstOrNull()) }
    var selectedInsurance by remember { mutableStateOf<InsuranceOption?>(null) }
    var showImageGallery by remember { mutableStateOf(false) }
    var showBookingSheet by remember { mutableStateOf(false) }
    val displayPricePerDay = car.pricePerDay + (selectedInsurance?.pricePerDay ?: 0.0)
    Scaffold(
        bottomBar = {
            BottomBookingBar(
                pricePerDay = displayPricePerDay,
                selectedColorName = selectedColor?.name,
                onBookNow = { showBookingSheet = true }
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .background(BackgroundPrimary),
            contentPadding = PaddingValues(bottom = 16.dp)
        ) {
            item {
                ImageGalleryCarousel(
                    images = car.images.toList(),
                    onImageTap = { showImageGallery = true }
                )
            }

            item {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 16.dp)
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.Top
                    ) {
                        Column {
                            Text(car.make, style = MaterialTheme.typography.headlineMedium)
                            Text(
                                car.model,
                                style = MaterialTheme.typography.headlineLarge,
                                fontWeight = FontWeight.Bold,
                                color = LuxuryGold
                            )
                        }
                        Column(horizontalAlignment = Alignment.End) {
                            Text(
                                "$${car.pricePerDay.toInt()}",
                                style = MaterialTheme.typography.headlineMedium,
                                fontWeight = FontWeight.Bold
                            )
                            Text("per day", style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                        }
                    }
                    Row(
                        modifier = Modifier.padding(top = 8.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        RatingBar(rating = car.rating, size = 16)
                        Text(
                            " • ${car.reviewCount} reviews",
                            style = MaterialTheme.typography.bodyMedium,
                            color = TextSecondary
                        )
                        Spacer(modifier = Modifier.weight(1f))
                        IconButton(onClick = { /* toggle favorite */ }) {
                            Icon(
                                imageVector = Icons.Default.Star,
                                contentDescription = null,
                                tint = LuxuryGold
                            )
                        }
                    }
                }
            }

            item { Divider(modifier = Modifier.padding(horizontal = 16.dp), color = SurfaceSecondary) }

            item {
                LazyRow(
                    horizontalArrangement = Arrangement.spacedBy(24.dp),
                    contentPadding = PaddingValues(horizontal = 16.dp, vertical = 12.dp)
                ) {
                    item { SpecItem(icon = "🏁", title = "Top Speed", value = "${car.topSpeed} mph") }
                    item { SpecItem(icon = "⏱️", title = "0-60 mph", value = "${String.format("%.1f", car.zeroToSixty)}s") }
                    item { SpecItem(icon = "🐎", title = "Horsepower", value = "${car.horsepower} HP") }
                    item { SpecItem(icon = "⚙️", title = "Transmission", value = car.transmission.name) }
                    item { SpecItem(icon = "⛽", title = "Fuel", value = car.fuelType.name) }
                    item { SpecItem(icon = "👥", title = "Seats", value = "${car.seats}") }
                }
            }

            item { Divider(modifier = Modifier.padding(horizontal = 16.dp), color = SurfaceSecondary) }

            item {
                Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp)) {
                    Text("Description", style = MaterialTheme.typography.titleMedium)
                    Text(
                        car.description,
                        style = MaterialTheme.typography.bodyMedium,
                        color = TextSecondary,
                        modifier = Modifier.padding(top = 8.dp)
                    )
                }
            }

            item {
                Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
                    Text("Features & Amenities", style = MaterialTheme.typography.titleMedium)

                    Column(
                        modifier = Modifier.padding(top = 12.dp),
                        verticalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        car.features.toList().chunked(2).forEach { rowFeatures ->
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.spacedBy(12.dp)
                            ) {
                                rowFeatures.forEach { feature ->
                                    Box(modifier = Modifier.weight(1f)) {
                                        FeatureChip(feature = feature)
                                    }
                                }
                                if (rowFeatures.size == 1) {
                                    Spacer(modifier = Modifier.weight(1f))
                                }
                            }
                        }
                    }
                }
            }

            if (car.colorOptions.count > 0) {
                item {
                    Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
                        Text("Exterior Color", style = MaterialTheme.typography.titleMedium)

                        LazyRow(
                            horizontalArrangement = Arrangement.spacedBy(16.dp),
                            modifier = Modifier.padding(top = 12.dp)
                        ) {
                            items(car.colorOptions.toList(), key = { it.name }) { color ->
                                ColorOptionChip(
                                    color = color,
                                    isSelected = selectedColor == color,
                                    onClick = { selectedColor = color }
                                )
                            }
                        }
                    }
                }
            }

            item {
                Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
                    Text("Insurance Protection", style = MaterialTheme.typography.titleMedium)
                    car.insuranceOptions.forEach { insurance ->
                        InsuranceCard(
                            insurance = insurance,
                            isSelected = selectedInsurance?.type == insurance.type,
                            onClick = { selectedInsurance = insurance }
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                    }
                }
            }

            item {
                Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
                    Text("Pickup Location", style = MaterialTheme.typography.titleMedium)
                    DealerInfoCard(dealer = car.location, modifier = Modifier.padding(top = 12.dp))
                }
            }

            item {
                Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Reviews", style = MaterialTheme.typography.titleMedium)
                        TextButton(onClick = { /* see all */ }) {
                            Text("See All", color = LuxuryGold)
                        }
                    }
                    ReviewCard(
                        name = "John D.",
                        rating = 5.0,
                        date = "2 days ago",
                        text = "Amazing experience! The car was in pristine condition and the staff was incredibly professional."
                    )
                    ReviewCard(
                        name = "Sarah M.",
                        rating = 4.8,
                        date = "1 week ago",
                        text = "Smooth rental process. The car was a dream to drive."
                    )
                }
            }

            val similarCars = viewModel.similarCars(car)
            if (similarCars.count > 0) {
                item {
                    Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 8.dp)) {
                        Text("You May Also Like", style = MaterialTheme.typography.titleMedium)
                        LazyRow(
                            horizontalArrangement = Arrangement.spacedBy(16.dp),
                            modifier = Modifier.padding(top = 12.dp)
                        ) {
                            items(similarCars.toList(), key = { it.id.toString() }) { similarCar ->
                                SimilarCarCard(
                                    car = similarCar,
                                    onClick = { navController.navigate("carDetail/${similarCar.id}") }
                                )
                            }
                        }
                    }
                }
            }
        }
    }

    if (showImageGallery) {
        FullScreenImageGallery(
            images = car.images.toList(),
            onDismiss = { showImageGallery = false }
        )
    }

    if (showBookingSheet) {
        LaunchedEffect(Unit) {
            showBookingSheet = false

            val colorParam = selectedColor?.name?.let { "color=${android.net.Uri.encode(it)}" } ?: ""
            val insuranceParam = selectedInsurance?.type?.name?.let { "insurance=${android.net.Uri.encode(it)}" } ?: ""
            val queryParams = listOf(colorParam, insuranceParam).filter { it.isNotEmpty() }.joinToString("&")

            val route = if (queryParams.isNotEmpty()) "booking/${car.id}?$queryParams" else "booking/${car.id}"

            navController.navigate(route)
        }
    }
}

// ---------- Components ----------

/**
 * Renders the image gallery carousel for the car details.
 */
@Composable
fun ImageGalleryCarousel(images: List<String>, onImageTap: () -> Unit) {
    var currentIndex by remember { mutableIntStateOf(0) }
    Box(modifier = Modifier.height(300.dp).fillMaxWidth()) {
        if (images.isNotEmpty()) {
            AppImage(
                source = images[currentIndex],
                modifier = Modifier
                    .fillMaxSize()
                    .clickable { onImageTap() },
                contentScale = ContentScale.Crop
            )
            Row(
                modifier = Modifier
                    .align(Alignment.BottomCenter)
                    .padding(bottom = 16.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                repeat(images.size) { index ->
                    Box(
                        modifier = Modifier
                            .size(8.dp)
                            .clip(CircleShape)
                            .background(if (index == currentIndex) LuxuryGold else Color.White.copy(alpha = 0.5f))
                    )
                }
            }
            Row(modifier = Modifier.fillMaxSize()) {
                Box(modifier = Modifier
                    .weight(1f)
                    .fillMaxHeight()
                    .clickable { if (currentIndex > 0) currentIndex-- })
                Box(modifier = Modifier
                    .weight(1f)
                    .fillMaxHeight()
                    .clickable { if (currentIndex < images.size - 1) currentIndex++ })
            }
        }
    }
}

@Composable
fun SpecItem(icon: String, title: String, value: String) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Box(
            modifier = Modifier
                .size(40.dp)
                .clip(CircleShape)
                .background(LuxuryGold.copy(alpha = 0.1f)),
            contentAlignment = Alignment.Center
        ) {
            Text(icon, fontSize = 20.sp)
        }
        Text(value, style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.SemiBold)
        Text(title, style = MaterialTheme.typography.labelSmall, color = TextSecondary)
    }
}

@Composable
fun FeatureChip(feature: Car.Feature) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier.padding(vertical = 4.dp)
    ) {
        Icon(
            imageVector = Icons.Default.Info,
            contentDescription = null,
            tint = LuxuryGold,
            modifier = Modifier.size(16.dp)
        )
        Spacer(modifier = Modifier.width(8.dp))
        Text(feature.name, style = MaterialTheme.typography.bodyMedium)
    }
}

@Composable
fun ColorOptionChip(color: CarColor, isSelected: Boolean, onClick: () -> Unit) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Box(
            modifier = Modifier
                .size(40.dp)
                .clip(CircleShape)
                .background(Color(android.graphics.Color.parseColor(color.hexCode)))
                .border(
                    width = if (isSelected) 3.dp else 0.dp,
                    color = LuxuryGold,
                    shape = CircleShape
                )
                .clickable { onClick() }
        )
        Text(color.name, style = MaterialTheme.typography.labelSmall, modifier = Modifier.padding(top = 4.dp))
        if (color.pricePremium > 0) {
            Text("+$${color.pricePremium.toInt()}", style = MaterialTheme.typography.labelSmall, color = LuxuryGold)
        }
    }
}

@Composable
fun InsuranceCard(insurance: InsuranceOption, isSelected: Boolean, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() },
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = SurfacePrimary),
        border = if (isSelected) BorderStroke(2.dp, LuxuryGold) else null
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Text(insurance.name, style = MaterialTheme.typography.titleSmall)
                Text(insurance.description, style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                Text("Coverage: ${insurance.coverage}", style = MaterialTheme.typography.labelSmall, color = TextSecondary)
            }
            Column(horizontalAlignment = Alignment.End) {
                Text("$${insurance.pricePerDay.toInt()}/day", style = MaterialTheme.typography.titleSmall, color = LuxuryGold)
                Icon(
                    imageVector = Icons.Default.CheckCircle,
                    contentDescription = null,
                    tint = if (isSelected) LuxuryGold else Color.Gray.copy(alpha = 0.3f)
                )
            }
        }
    }
}

@Composable
fun DealerInfoCard(dealer: DealerLocation, modifier: Modifier = Modifier) {
    Card(
        modifier = modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(imageVector = Icons.Default.LocationOn, contentDescription = null, tint = LuxuryGold)
                Spacer(modifier = Modifier.width(8.dp))
                Text(dealer.name, style = MaterialTheme.typography.titleSmall, modifier = Modifier.weight(1f))
                RatingBar(rating = dealer.rating, size = 14)
            }
            Text(dealer.fullAddress, style = MaterialTheme.typography.bodyMedium, color = TextSecondary, modifier = Modifier.padding(top = 4.dp))
            Row(
                modifier = Modifier.fillMaxWidth().padding(top = 8.dp),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Text(dealer.phone, style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                Text("Open until 8 PM", style = MaterialTheme.typography.labelSmall, color = TextSecondary)
            }
            Button(
                onClick = { /* open maps */ },
                modifier = Modifier.fillMaxWidth().padding(top = 12.dp),
                colors = ButtonDefaults.buttonColors(containerColor = LuxuryGold, contentColor = Color.Black),
                shape = CircleShape
            ) {
                Icon(imageVector = Icons.Default.Map, contentDescription = null)
                Text("Get Directions")
            }
        }
    }
}

@Composable
fun ReviewCard(name: String, rating: Double, date: String, text: String) {
    Card(
        modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
    ) {
        Column(modifier = Modifier.padding(12.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(modifier = Modifier.size(40.dp).clip(CircleShape).background(SurfaceSecondary), contentAlignment = Alignment.Center) {
                    Text(name.take(1).uppercase(), color = LuxuryGold, fontWeight = FontWeight.Bold)
                }
                Spacer(modifier = Modifier.width(12.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text(name, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
                    RatingBar(rating = rating, size = 12)
                }
                Text(date, style = MaterialTheme.typography.labelSmall, color = TextSecondary)
            }
            Text(text, style = MaterialTheme.typography.bodySmall, color = TextSecondary, modifier = Modifier.padding(top = 8.dp))
        }
    }
}

/**
 * Card displaying a similar car option.
 */
@Composable
fun SimilarCarCard(car: Car, onClick: () -> Unit) {
    Card(
        modifier = Modifier.width(160.dp).clickable { onClick() },
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
    ) {
        Column {
            AppImage(
                source = car.images.firstOrNull(),
                modifier = Modifier.height(100.dp).fillMaxWidth(),
                contentScale = ContentScale.Crop
            )
            Column(modifier = Modifier.padding(8.dp)) {
                Text(car.make, style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                Text(car.model, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.SemiBold)
                Text("$${car.pricePerDay.toInt()}/day", style = MaterialTheme.typography.labelSmall, color = LuxuryGold, fontWeight = FontWeight.Bold)
            }
        }
    }
}

@Composable
fun BottomBookingBar(pricePerDay: Double, selectedColorName: String?, onBookNow: () -> Unit) {
    Surface(
        modifier = Modifier.fillMaxWidth(),
        tonalElevation = 8.dp,
        color = MaterialTheme.colorScheme.surface.copy(alpha = 0.95f)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 16.dp, vertical = 12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Row(verticalAlignment = Alignment.Bottom) {
                    Text(
                        "$${pricePerDay.toInt()}",
                        style = MaterialTheme.typography.titleLarge,
                        color = LuxuryGold,
                        fontWeight = FontWeight.Bold
                    )
                    Text(" / day", style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                }
                selectedColorName?.let {
                    Text("Color: $it", style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                }
            }
            Spacer(modifier = Modifier.weight(1f))
            Button(
                onClick = onBookNow,
                colors = ButtonDefaults.buttonColors(containerColor = LuxuryGold, contentColor = Color.Black),
                shape = CircleShape
            ) {
                Text("Continue to Book", modifier = Modifier.padding(horizontal = 8.dp))
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FullScreenImageGallery(images: List<String>, onDismiss: () -> Unit) {
    var currentIndex by remember { mutableIntStateOf(0) }
    ModalBottomSheet(
        onDismissRequest = onDismiss,
        containerColor = Color.Black,
        dragHandle = null
    ) {
        Box(modifier = Modifier.fillMaxSize()) {
            AppImage(
                source = images[currentIndex],
                modifier = Modifier.fillMaxSize(),
                contentScale = ContentScale.Fit
            )
            Row(
                modifier = Modifier
                    .align(Alignment.TopEnd)
                    .padding(16.dp)
            ) {
                IconButton(onClick = onDismiss) {
                    Icon(
                        imageVector = Icons.Default.Close,
                        contentDescription = "Close",
                        tint = Color.White
                    )
                }
            }
            Text(
                "${currentIndex + 1} / ${images.size}",
                color = Color.White,
                modifier = Modifier
                    .align(Alignment.TopCenter)
                    .padding(16.dp)
            )
            Row(modifier = Modifier.fillMaxSize()) {
                Box(modifier = Modifier
                    .weight(1f)
                    .fillMaxHeight()
                    .clickable { if (currentIndex > 0) currentIndex-- })
                Box(modifier = Modifier
                    .weight(1f)
                    .fillMaxHeight()
                    .clickable { if (currentIndex < images.size - 1) currentIndex++ })
            }
        }
    }
}