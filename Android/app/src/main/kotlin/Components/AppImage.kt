package complex.skip.app.ui.screens

import android.content.Context
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DirectionsCar
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import coil.compose.AsyncImage
import complex.skip.app.Theme.LuxuryGold
import complex.skip.app.Theme.SurfaceSecondary
import java.util.LinkedList

/**
 * Renders an image from either a remote URL or the local Android assets folder.
 * Matches the behavior of the iOS AppImage wrapper.
 */
@Composable
fun AppImage(
    source: String?,
    modifier: Modifier = Modifier,
    contentScale: ContentScale = ContentScale.Crop
) {
    if (source.isNullOrEmpty()) {
        PlaceholderImage(modifier)
        return
    }

    if (source.startsWith("http://") || source.startsWith("https://")) {
        AsyncImage(
            model = source,
            contentDescription = null,
            modifier = modifier,
            contentScale = contentScale
        )
    } else {
        val context = LocalContext.current
        // Onthoudt het pad zodat we niet bij elke scroll de map opnieuw hoeven te scannen
        val assetUri = remember(source) { findAssetPath(context, source) }

        if (assetUri != null) {
            AsyncImage(
                model = assetUri,
                contentDescription = null,
                modifier = modifier,
                contentScale = contentScale
            )
        } else {
            PlaceholderImage(modifier)
        }
    }
}

/**
 * Slimme zoekfunctie die de hele Android assets map doorzoekt.
 * Het negeert hoofdletters/kleine letters (omdat Android case-sensitive is en iOS niet).
 */
private fun findAssetPath(context: Context, imageName: String): String? {
    val assetManager = context.assets
    val extensions = listOf(".jpg", ".jpeg", ".png", ".webp", "")

    val queue = LinkedList<String>()
    queue.add("") // Begin in de hoofdmap van de assets

    while (queue.isNotEmpty()) {
        val currentDir = queue.removeFirst()
        try {
            val items = assetManager.list(currentDir) ?: continue
            for (item in items) {
                val fullPath = if (currentDir.isEmpty()) item else "$currentDir/$item"

                var isMatch = false
                // Check of het bestand overeenkomt met de gezochte afbeelding (negeer case)
                for (ext in extensions) {
                    if (item.equals("$imageName$ext", ignoreCase = true)) {
                        isMatch = true
                        try {
                            // Controleer of we het bestand echt kunnen lezen
                            assetManager.open(fullPath).close()
                            return "file:///android_asset/$fullPath"
                        } catch (e: Exception) { }
                    }
                }

                // Als het geen bekende afbeelding/bestand is, is het waarschijnlijk een map.
                // We voegen deze toe aan de queue om verder in te zoeken.
                if (!isMatch) {
                    val lowerItem = item.lowercase()
                    if (!lowerItem.endsWith(".jpg") &&
                        !lowerItem.endsWith(".jpeg") &&
                        !lowerItem.endsWith(".png") &&
                        !lowerItem.endsWith(".webp") &&
                        !lowerItem.endsWith(".json") &&
                        !lowerItem.endsWith(".xml")) {
                        queue.add(fullPath)
                    }
                }
            }
        } catch (e: Exception) {
            // Negeer mappen die we niet kunnen lezen
        }
    }
    return null
}

/**
 * Displays a fallback placeholder when an image cannot be loaded or found.
 */
@Composable
private fun PlaceholderImage(modifier: Modifier) {
    Box(
        modifier = modifier.background(SurfaceSecondary),
        contentAlignment = Alignment.Center
    ) {
        Icon(
            imageVector = Icons.Default.DirectionsCar,
            contentDescription = "Placeholder",
            tint = LuxuryGold.copy(alpha = 0.5f)
        )
    }
}