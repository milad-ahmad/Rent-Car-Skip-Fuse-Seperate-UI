package complex.skip.app.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DirectionsCar
import androidx.compose.material.icons.filled.DateRange
import androidx.compose.material.icons.filled.Schedule
import androidx.compose.material.icons.filled.ArrowForward
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import coil.compose.AsyncImage
import complex.skip.app.Rental
import complex.skip.app.RentalViewModel
import java.text.SimpleDateFormat
import java.util.*
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import complex.skip.app.Theme.LuxuryGold
import complex.skip.app.Theme.SurfacePrimary
import complex.skip.app.Theme.TextSecondary
import skip.foundation.Date as SwiftDate

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RentalsScreen(viewModel: RentalViewModel, navController: NavController) {
    var selectedSegment by remember { mutableIntStateOf(0) }
    val rentals = viewModel.currentUser?.rentalHistory ?: emptyList()
    val filtered = rentals.filter {
        when (selectedSegment) {
            0 -> it.status == Rental.RentalStatus.upcoming
            1 -> it.status == Rental.RentalStatus.active
            else -> it.status == Rental.RentalStatus.completed || it.status == Rental.RentalStatus.cancelled
        }
    }

    Scaffold(
        topBar = { TopAppBar(title = { Text("My Rentals") }) }
    ) { padding ->
        // Use LazyColumn as root and put TabRow as the first item
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding),
            contentPadding = PaddingValues(bottom = 16.dp)
        ) {
            // TabRow as a sticky header (optional)
            item {
                TabRow(selectedTabIndex = selectedSegment) {
                    Tab(selected = selectedSegment == 0, onClick = { selectedSegment = 0 }, text = { Text("Upcoming") })
                    Tab(selected = selectedSegment == 1, onClick = { selectedSegment = 1 }, text = { Text("Active") })
                    Tab(selected = selectedSegment == 2, onClick = { selectedSegment = 2 }, text = { Text("Past") })
                }
            }

            if (filtered.isEmpty()) {
                item {
                    Box(modifier = Modifier.fillMaxSize().padding(top = 64.dp), contentAlignment = Alignment.Center) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            Icon(imageVector = Icons.Default.DirectionsCar, contentDescription = null, modifier = Modifier.size(60.dp), tint = LuxuryGold.copy(alpha = 0.5f))
                            Text("No Rentals Yet", style = MaterialTheme.typography.titleLarge)
                            Text("Your rental history will appear here", color = TextSecondary)
                            Button(
                                onClick = { navController.navigate("explore") },
                                colors = ButtonDefaults.buttonColors(containerColor = LuxuryGold, contentColor = Color.Black),
                                shape = CircleShape,
                                modifier = Modifier.padding(top = 16.dp)
                            ) {
                                Text("Browse Cars")
                            }
                        }
                    }
                }
            } else {
                items(filtered, key = { it.bookingReference.toString() }) { rental ->
                    RentalCard(rental = rental)
                }
            }
        }
    }
}

@Composable
fun RentalCard(rental: Rental) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row {
                AsyncImage(
                    model = rental.car.images.firstOrNull(),
                    contentDescription = null,
                    modifier = Modifier.size(80.dp, 60.dp).clip(RoundedCornerShape(8.dp))
                )
                Spacer(modifier = Modifier.width(12.dp))
                Column(modifier = Modifier.weight(1f)) {
                    Text("${rental.car.year} ${rental.car.make} ${rental.car.model}", style = MaterialTheme.typography.titleMedium)
                    Text("Ref: ${rental.bookingReference}", style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                }
                StatusBadge(status = rental.status)
            }
            Divider(modifier = Modifier.padding(vertical = 12.dp))
            Row(horizontalArrangement = Arrangement.SpaceBetween) {
                Column {
                    Label(text = formatDate(rental.startDate), icon = Icons.Default.DateRange)
                    Label(text = rental.pickupTime, icon = Icons.Default.Schedule)
                }
                Icon(imageVector = Icons.Default.ArrowForward, contentDescription = null, tint = LuxuryGold)
                Column(horizontalAlignment = Alignment.End) {
                    Label(text = formatDate(rental.endDate), icon = Icons.Default.DateRange)
                    Label(text = rental.returnTime, icon = Icons.Default.Schedule)
                }
            }
            Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.padding(top = 8.dp)) {
                Text("Total: $${"%.2f".format(rental.totalPrice)}", style = MaterialTheme.typography.titleSmall, fontWeight = FontWeight.SemiBold)
                TextButton(onClick = {}) { Text("View Details", color = LuxuryGold) }
            }
        }
    }
}

@Composable
fun Label(text: String, icon: ImageVector) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Icon(imageVector = icon, contentDescription = null, modifier = Modifier.size(12.dp), tint = TextSecondary)
        Spacer(modifier = Modifier.width(4.dp))
        Text(text, style = MaterialTheme.typography.labelSmall, color = TextSecondary)
    }
}

@Composable
fun StatusBadge(status: Rental.RentalStatus) {
    val color = when (status) {
        Rental.RentalStatus.upcoming -> Color.Blue
        Rental.RentalStatus.active -> Color.Green
        Rental.RentalStatus.completed -> Color.Gray
        Rental.RentalStatus.cancelled -> Color.Red
    }
    Box(modifier = Modifier.background(color.copy(alpha = 0.2f), CircleShape).padding(horizontal = 8.dp, vertical = 4.dp)) {
        Text(status.name, style = MaterialTheme.typography.labelSmall, color = color)
    }
}

fun formatDate(date: SwiftDate): String {
    val javaDate = Date(date.timeIntervalSince1970.toLong() * 1000)
    return SimpleDateFormat("MMM dd, yyyy", Locale.getDefault()).format(javaDate)
}