package complex.skip.app.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import complex.skip.app.RentalViewModel
import complex.skip.app.Theme.LuxuryGold
import complex.skip.app.Theme.SurfacePrimary
import complex.skip.app.Theme.SurfaceSecondary
import complex.skip.app.Theme.TextSecondary
import java.util.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ProfileScreen(viewModel: RentalViewModel) {
    val user = viewModel.currentUser

    Scaffold(
        topBar = { TopAppBar(title = { Text("Profile") }) }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding),
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            item {
                Card(
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
                ) {
                    Column(
                        modifier = Modifier.fillMaxWidth().padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        AsyncImage(
                            model = user?.profileImage,
                            contentDescription = null,
                            modifier = Modifier.size(100.dp).clip(CircleShape).background(SurfaceSecondary)
                        )
                        Text(
                            user?.name ?: "Guest User",
                            style = MaterialTheme.typography.titleLarge,
                            modifier = Modifier.padding(top = 8.dp)
                        )
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                imageVector = Icons.Default.Star,
                                contentDescription = null,
                                tint = tierColor(user?.membershipTier)
                            )
                            Text(
                                user?.membershipTier?.name ?: "Classic",
                                color = tierColor(user?.membershipTier)
                            )
                        }
                        Text(
                            "Member since ${user?.memberSince?.let { formatDate(it) } ?: "N/A"}",
                            style = MaterialTheme.typography.labelSmall,
                            color = TextSecondary
                        )
                    }
                }
            }

            item {
                Card(
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(16.dp),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column {
                            Text("Available Balance", style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                            Text(
                                "$${"%.2f".format(user?.balance ?: 0.0)}",
                                style = MaterialTheme.typography.headlineMedium,
                                color = LuxuryGold
                            )
                        }
                        Button(
                            onClick = { viewModel.addBonusCredits(500.0) },
                            colors = ButtonDefaults.buttonColors(containerColor = LuxuryGold, contentColor = Color.Black),
                            shape = CircleShape
                        ) {
                            Text("Add Demo Funds")
                        }
                    }
                }
            }

            item {
                Card(
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Row(horizontalArrangement = Arrangement.SpaceBetween) {
                            Text("Rewards Points", style = MaterialTheme.typography.titleMedium)
                            Text("${user?.rewards?.points ?: 0} pts", color = LuxuryGold)
                        }
                        LinearProgressIndicator(
                            progress = (user?.rewards?.points ?: 0).toFloat() / 25000f,
                            modifier = Modifier.fillMaxWidth().height(4.dp),
                            color = LuxuryGold
                        )
                        Text(
                            "${user?.rewards?.nextTierPoints ?: 25000} points to next tier",
                            style = MaterialTheme.typography.labelSmall,
                            color = TextSecondary
                        )
                        Divider(modifier = Modifier.padding(vertical = 12.dp))
                        user?.rewards?.benefits?.forEach { benefit ->
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(
                                    imageVector = Icons.Default.Info,
                                    contentDescription = null,
                                    tint = LuxuryGold
                                )
                                Spacer(modifier = Modifier.width(12.dp))
                                Column {
                                    Text(benefit.title, style = MaterialTheme.typography.bodyMedium, fontWeight = FontWeight.Medium)
                                    Text(benefit.description, style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                                }
                            }
                        }
                    }
                }
            }

            item {
                Card(
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
                ) {
                    Column {
                        ProfileMenuItem(
                            icon = Icons.Default.Payment,
                            title = "Payment Methods",
                            value = "${user?.paymentMethods?.count ?: 0} cards"
                        )
                        Divider()
                        ProfileMenuItem(
                            icon = Icons.Default.Favorite,
                            title = "Saved Cars",
                            value = "${user?.savedCars?.count ?: 0}"
                        )
                        Divider()
                        ProfileMenuItem(
                            icon = Icons.Default.History,
                            title = "Rental History"
                        )
                        Divider()
                        ProfileMenuItem(
                            icon = Icons.Default.Settings,
                            title = "Settings"
                        )
                        Divider()
                        ProfileMenuItem(
                            icon = Icons.Default.Help,
                            title = "Help & Support"
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun tierColor(tier: complex.skip.app.UserProfile.MembershipTier?): Color {
    return when (tier) {
        complex.skip.app.UserProfile.MembershipTier.classic -> Color.Gray
        complex.skip.app.UserProfile.MembershipTier.silver -> Color(0xFFC0C0C0)
        complex.skip.app.UserProfile.MembershipTier.gold -> LuxuryGold
        complex.skip.app.UserProfile.MembershipTier.platinum -> Color(0xFFE5E4E2)
        complex.skip.app.UserProfile.MembershipTier.black -> Color.Black
        else -> Color.Gray
    }
}

@Composable
fun ProfileMenuItem(icon: androidx.compose.ui.graphics.vector.ImageVector, title: String, value: String? = null) {
    Row(
        modifier = Modifier.fillMaxWidth().clickable {}.padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(imageVector = icon, contentDescription = null, tint = LuxuryGold)
        Spacer(modifier = Modifier.width(16.dp))
        Text(title, modifier = Modifier.weight(1f))
        value?.let { Text(it, color = TextSecondary) }
        Icon(imageVector = Icons.Default.ChevronRight, contentDescription = null, tint = TextSecondary)
    }
}
