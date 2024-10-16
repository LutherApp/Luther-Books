<script setup lang="ts">
const { data: page } = await useAsyncData('books', () => queryContent('/books').findOne())
if (!page.value) {
  throw createError({ statusCode: 404, statusMessage: 'Page not found', fatal: true })
}

useSeoMeta({
  title: page.value.title,
  ogTitle: page.value.title,
  description: page.value.description,
  ogDescription: page.value.description
})

defineOgImage({
  component: 'Saas',
  // @ts-expect-error Object literal may only specify known properties, and 'title' does not exist in type 'OgImageOptions<"NuxtSeo"> | OgImagePrebuilt'.
  title: page.value.title,
  description: page.value.description
})

const isYearly = ref(false)

/**
 * Table
 * Source:
 * https://ui.nuxt.com/components/table
 */

const columns = [{
  key: 'author',
  label: 'Author',
  sortable: true,
  direction: 'desc' as const
}, {
  key: 'title',
  label: 'Title',
  sortable: true,
  direction: 'desc' as const
}, {
  key: 'format',
  label: 'Format',
  sortable: true,
  direction: 'desc' as const
}]

const rows = [{
  id: 1,
  author: 'Mueller',
  title: 'Christian Dogmatics',
  format: 'MD',
  url: 'https://christian-dogmatics.vercel.app'
}, {
  id: 2,
  author: 'Luther',
  title: 'Kirkepostille',
  format: 'MD',
  url: 'http://www.lutherdansk.dk/KP%20-%20enkeltpr%C3%A6dikener/KP%20-%20Forside%20med%20indeks/index.htm'
}, {
  id: 3,
  author: 'Luther',
  title: 'Church-Postil',
  format: 'PDF',
  url: 'https://www.lutheranlibrary.org/pdf/504-luther-church-postil-complete.pdf'
}, {
  id: 4,
  author: 'Luther',
  title: 'Church-Postil',
  format: 'html',
  url: '/books'
}, {
  id: 5,
  author: 'Luther',
  title: 'Small catechism',
  format: 'html',
  url: 'https://catechism.cph.org/'
}, {
  id: 6,
  author: 'Luther',
  title: '95 Theses',
  format: 'html',
  url: 'https://godrules.net/library/luther/205luther0.htm'
}, {
  id: 7,
  author: 'Melanchthon',
  title: 'The Book of Concord',
  format: 'PDF',
  url: 'https://www.lutheranlibrary.org/pdf/250-jacobs-book-of-concord.pdf'
}, {
  id: 8,
  author: 'Melanchthon',
  title: 'The Book of Concord',
  format: 'html',
  url: 'https://bookofconcord.org/'
}, {
  id: 9,
  author: 'Luther',
  title: 'Overview Luther in english',
  format: 'html',
  url: 'https://godrules.net/library/luther/luther.htm'
}]

const selected = ref([rows[1]])

async function openUrl(row) {
  const index = selected.value.findIndex((item) => item.id === row.id)
  if (index === -1) {
    selected.value.push(row)
    await navigateTo(row.url, { open: { target: '_blank' } })
  } else {
    selected.value.splice(index, 1)
    await navigateTo(row.url, { open: { target: '_blank' } })
  }
}

const q = ref('')

const filterRows = computed(() => {
  if (!q.value) {
    return rows
  }

  return rows.filter((rows) => {
    return Object.values(rows).some((value) => {
      return String(value).toLowerCase().includes(q.value.toLowerCase())
    })
  })
})
</script>

<template>
  <div v-if="page">
    <ULandingSection
      :title="page.title"
    >
      <ULandingFAQ
        :items="page.faq.items"
        multiple
        class="max-w-4xl mx-auto"
      />
    </ULandingSection>

    <ULandingSection>
      <UInput
        v-model="q"
        placeholder="Filter books..."
      />

      <UTable
        :columns="columns"
        :rows="filterRows"
        @select="openUrl"
      />
    </ULandingSection>
  </div>
</template>
